from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship

from app.database import Base


class Media(Base):
    __tablename__ = "medias"

    id = Column(Integer, primary_key=True)
    url = Column(String, nullable=False)
    caption = Column(String)

    event_id = Column(Integer, ForeignKey("events.id"), nullable=False)
    event = relationship("Event", back_populates="medias")

    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    owner = relationship("User", back_populates="medias")
