from fastapi import APIRouter, Depends, HTTPException, Request, status

from app.auth import get_current_user
from app.database import get_db
from app.models import trip as models
from app.schemas import trip as schemas
from app.utils import RATE_LIMIT, limiter

router = APIRouter()


@router.post("", response_model=schemas.Trip)
@limiter.limit(RATE_LIMIT)
async def create_trip(
    request: Request,
    trip: schemas.TripCreate,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_trip = models.Trip(**trip.model_dump(), owner_id=user.id)
    db.add(db_trip)
    db.commit()
    db.refresh(db_trip)
    return db_trip


@router.get("", response_model=list[schemas.Trip])
async def get_trips(
    request: Request, db=Depends(get_db), user=Depends(get_current_user)
):
    return (
        db.query(models.Trip)
        .filter(models.Trip.owner_id == user.id)
        .order_by(models.Trip.start_date)
        .all()
    )


@router.get("/{trip_id}", response_model=schemas.Trip)
async def get_trip(
    request: Request, trip_id: int, db=Depends(get_db), user=Depends(get_current_user)
):
    db_trip = __get_trip(trip_id, db, user.id)
    if not db_trip:
        raise HTTPException(status_code=404, detail="Trip not found")
    else:
        return db_trip


@router.put("/{trip_id}", response_model=schemas.Trip)
async def update_trip(
    request: Request,
    trip_id: int,
    trip: schemas.TripUpdate,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_trip = __get_trip(trip_id, db, user.id)
    if not db_trip:
        raise HTTPException(status_code=404, detail="Trip not found")
    else:
        for var, value in vars(trip).items():
            setattr(db_trip, var, value) if value else None
        db.commit()
        db.refresh(db_trip)
        return db_trip


@router.delete("/{trip_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_trip(
    request: Request, trip_id: int, db=Depends(get_db), user=Depends(get_current_user)
):
    db_trip = __get_trip(trip_id, db, user.id)
    if not db_trip:
        raise HTTPException(status_code=404, detail="Trip not found")
    else:
        db.delete(db_trip)
        db.commit()
        return {"detail": "Trip deleted"}


# Helpers


def __get_trip(trip_id: int, db, owner_id: int):
    return (
        db.query(models.Trip)
        .filter(models.Trip.owner_id == owner_id)
        .filter(models.Trip.id == trip_id)
        .first()
    )
