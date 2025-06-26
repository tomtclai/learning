from sqlalchemy import Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.database import Base


class Event(Base):
    __tablename__ = "events"

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    note = Column(String)
    date = Column(DateTime, nullable=False)
    transition_from_previous = Column(String)

    location = relationship(
        "Location", uselist=False, back_populates="event", cascade="all, delete-orphan"
    )
    medias = relationship("Media", back_populates="event", cascade="all, delete-orphan")

    trip_id = Column(Integer, ForeignKey("trips.id"), nullable=False)
    trip = relationship("Trip", back_populates="events")

    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    owner = relationship("User", back_populates="events")

    created_at = Column(DateTime(timezone=True), server_default=func.now())
