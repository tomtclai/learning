from datetime import datetime

from pydantic import BaseModel

from .event import Event
from .utils import iso8601


class TripBase(BaseModel):
    name: str
    start_date: datetime
    end_date: datetime

    class Config:
        json_encoders = {datetime: iso8601}


class TripCreate(TripBase):
    pass


class TripUpdate(TripBase):
    pass


class Trip(TripBase):
    id: int
    events: list[Event] = []
