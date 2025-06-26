from pydantic import BaseModel


class MediaBase(BaseModel):
    caption: str | None = None


class MediaCreate(MediaBase):
    base64_data: str
    event_id: int


class MediaUpdate(MediaBase):
    base64_data: str
    id: int


class Media(MediaBase):
    id: int
    url: str
