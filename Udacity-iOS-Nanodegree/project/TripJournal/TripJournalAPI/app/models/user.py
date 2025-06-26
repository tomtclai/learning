from sqlalchemy import Column, DateTime, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    username = Column(String, unique=True, nullable=False)
    hashed_password = Column(String, nullable=False)

    trips = relationship("Trip", back_populates="owner", cascade="all, delete-orphan")
    events = relationship(
        "Event",
        back_populates="owner",
        cascade="all, delete-orphan",
        order_by="Trip.start_date.asc()",
    )
    locations = relationship(
        "Location", back_populates="owner", cascade="all, delete-orphan"
    )
    medias = relationship("Media", back_populates="owner", cascade="all, delete-orphan")

    created_at = Column(DateTime(timezone=True), server_default=func.now())
