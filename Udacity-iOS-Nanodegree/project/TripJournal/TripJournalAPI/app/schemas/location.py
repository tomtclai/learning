from pydantic import BaseModel, Field
from typing_extensions import Annotated


class LocationBase(BaseModel):
    latitude: Annotated[float, Field(ge=-90, le=90)]
    longitude: Annotated[float, Field(ge=-180, le=180)]
    address: str | None = None


class LocationCreate(LocationBase):
    event_id: int


class LocationUpdate(LocationBase):
    pass


class Location(LocationBase):
    pass
