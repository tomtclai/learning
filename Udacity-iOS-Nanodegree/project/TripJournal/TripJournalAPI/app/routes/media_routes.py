import os
import base64
from io import BytesIO
from uuid import uuid4

from fastapi import APIRouter, Depends, File, HTTPException, Request, status
from PIL import Image as PILImage

from app.auth import get_current_user
from app.database import get_db
from app.models import media as models
from app.schemas import media as schemas
from app.utils import RATE_LIMIT, limiter

from .event_routes import __get_event

router = APIRouter()


@router.post("", response_model=schemas.Media)
@limiter.limit(RATE_LIMIT)
async def upload_media(
    request: Request,
    media: schemas.MediaCreate,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_event = __get_event(media.event_id, db, user.id)
    if not db_event:
        raise HTTPException(status_code=404, detail="Event not found")

    try:
        # Decode the base64 data string and validate that it's an image
        media_content = base64.b64decode(media.base64_data)
        PILImage.open(BytesIO(media_content))
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid media file")

    # Save the media file
    url = __save_media(media_content, request)

    db_media = models.Media(
        url=url, caption=media.caption, event_id=media.event_id, owner_id=user.id
    )
    db.add(db_media)
    db.commit()
    db.refresh(db_media)
    return db_media


@router.delete("/{media_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_media(
    request: Request,
    media_id: int,
    db=Depends(get_db),
    user=Depends(get_current_user),
):
    db_media = __get_media(media_id, db, user.id)
    if not db_media:
        raise HTTPException(status_code=404, detail="Media not found")
    else:
        # Delete the media file
        try:
            # Remove base url and get the path to the media file
            media_path = db_media.url.replace(str(request.base_url), "")
            os.remove(f"/{media_path}")
        except:
            pass  # If the file is not found, just ignore the error

        # Delete the db_media
        db.delete(db_media)
        db.commit()
        return {"detail": "Media deleted"}


# Helpers


def __save_media(media_content, request: Request):
    # Generate a new filename using a UUID
    new_filename = f"{uuid4()}.png"

    # Save the media file to a static directory
    with open(f"/static/{new_filename}", "wb") as f:
        f.write(media_content)

    # Use base URL and the path to the saved file as the URL
    return str(request.base_url) + f"static/{new_filename}"


def __get_media(media_id: int, db, owner_id: int):
    return (
        db.query(models.Media)
        .filter(models.Media.owner_id == owner_id)
        .filter(models.Media.id == media_id)
        .first()
    )
