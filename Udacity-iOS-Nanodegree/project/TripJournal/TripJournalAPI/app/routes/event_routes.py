from fastapi import APIRouter, Depends, HTTPException, Request, status

from app.auth import get_current_user
from app.database import get_db
from app.models import event as event_models
from app.models import location as location_models
from app.schemas import event as event_schemas
from app.utils import RATE_LIMIT, limiter

from .trip_routes import __get_trip

router = APIRouter()


@router.post("", response_model=event_schemas.Event)
@limiter.limit(RATE_LIMIT)
async def create_event(
    request: Request,
    event: event_schemas.EventCreate,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_trip = __get_trip(event.trip_id, db, user.id)
    if not db_trip:
        raise HTTPException(status_code=404, detail="Trip not found")
    else:
        event_dict = event.model_dump()
        location_data = event_dict.pop("location", None)
        location = (
            location_models.Location(**location_data, owner_id=user.id)
            if location_data
            else None
        )
        db_event = event_models.Event(**event_dict, location=location, owner_id=user.id)
        db.add(db_event)
        db.commit()
        db.refresh(db_event)
        return db_event


@router.get("/{event_id}", response_model=event_schemas.Event)
@limiter.limit(RATE_LIMIT)
async def get_event(
    request: Request,
    event_id: int,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_event = __get_event(event_id, db, user.id)
    if not db_event:
        raise HTTPException(status_code=404, detail="Event not found")
    else:
        return db_event


@router.put("/{event_id}", response_model=event_schemas.Event)
@limiter.limit(RATE_LIMIT)
async def update_event(
    request: Request,
    event_id: int,
    event: event_schemas.EventUpdate,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_event = __get_event(event_id, db, user.id)
    if not db_event:
        raise HTTPException(status_code=404, detail="Event not found")
    else:
        event_dict = event.model_dump(exclude_unset=True)
        location_data = event_dict.pop("location", None)
        if location_data is not None:
            if db_event.location:
                for var, value in location_data.items():
                    setattr(db_event.location, var, value)
            else:
                db_event.location = location_models.Location(
                    **location_data, owner_id=user.id
                )
        elif db_event.location:
            db.delete(db_event.location)
            db_event.location = None
        for var, value in event_dict.items():
            setattr(db_event, var, value)
        db.commit()
        db.refresh(db_event)
        return db_event


@router.delete("/{event_id}", status_code=status.HTTP_204_NO_CONTENT)
@limiter.limit(RATE_LIMIT)
async def delete_event(
    request: Request,
    event_id,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_event = __get_event(event_id, db, user.id)
    if not db_event:
        raise HTTPException(status_code=404, detail="Event not found")
    else:
        db.delete(db_event)
        db.commit()
        return {"detail": "Event deleted"}


# Helpers


def __get_event(event_id: int, db, owner_id: int):
    return (
        db.query(event_models.Event)
        .filter(event_models.Event.owner_id == owner_id)
        .filter(event_models.Event.id == event_id)
        .first()
    )
