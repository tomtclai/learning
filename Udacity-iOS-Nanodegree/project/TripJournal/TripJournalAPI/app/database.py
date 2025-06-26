from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Database URL for SQLite
DATABASE_URL = "sqlite:////db/app.db"

# Create the SQLAlchemy engine
engine = create_engine(
    DATABASE_URL, connect_args={"check_same_thread": False}  # Needed for SQLite
)

# SessionLocal class will be used to create database sessions
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base class for your models
Base = declarative_base()


# Dependency to get a database session and close it when the request is finished
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
