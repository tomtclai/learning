from os import environ as env

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from slowapi import Limiter
from slowapi.util import get_remote_address
from sqlalchemy.orm import Session
from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint
from starlette.requests import HTTPConnection

from app.database import get_db

# Secret key to encode and decode JWT tokens, fallback to default value if env var is not set
SECRET_KEY = env.get("ACCESS_TOKEN_SECRET_KEY", "DEBUG")

# Algorithm used to encode and decode JWT tokens
ALGORITHM = env.get("ACCESS_TOKEN_ALGORITHM", "HS256")

# Token expiration time in minutes
ACCESS_TOKEN_EXPIRE_MINUTES = int(env.get("ACCESS_TOKEN_EXPIRE_MINUTES", 60))

# General rate limit for the API
## More: https://limits.readthedocs.io/en/stable/quickstart.html#rate-limit-string-notation
RATE_LIMIT = env.get("RATE_LIMIT", "100/minute")

# Rate limiter
limiter = Limiter(key_func=get_remote_address)


# Dependency to get a database session
def get_db_session() -> Session:
    """
    Get a database session.
    """

    db = get_db()
    try:
        yield db
    finally:
        db.close()
