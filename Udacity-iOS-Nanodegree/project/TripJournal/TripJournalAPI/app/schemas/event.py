from datetime import datetime

from pydantic import BaseModel

from .media import Media
from .location import Location
from .utils import iso8601


class EventBase(BaseModel):
    name: str
    date: datetime
    note: str | None = None
    location: Location | None = None
    transition_from_previous: str | None = None

    class Config:
        json_encoders = {datetime: iso8601}


class EventCreate(EventBase):
    trip_id: int


class EventUpdate(EventBase):
    pass


class Event(EventBase):
    id: int
    medias: list[Media] = []
