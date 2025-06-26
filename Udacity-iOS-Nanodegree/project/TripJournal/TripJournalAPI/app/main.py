from fastapi import FastAPI, APIRouter
from fastapi.staticfiles import StaticFiles
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded

from app.database import Base, engine
from app.routes.auth_routes import router as auth_router
from app.routes.event_routes import router as event_router
from app.routes.media_routes import router as media_router
from app.routes.trip_routes import router as trip_router
from app.utils import limiter

Base.metadata.create_all(bind=engine)

app = FastAPI()

# Root
router = APIRouter()
@router.get("/")
async def root():
    return {"message": "Hello World"}

# Static files
app.mount("/static", StaticFiles(directory="/static"), name="static")

# Rate limiting
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Routes
app.include_router(router, tags=["Root"])
app.include_router(auth_router, tags=["Auth"])
app.include_router(trip_router, prefix="/trips", tags=["Trips"])
app.include_router(event_router, prefix="/events", tags=["Events"])
app.include_router(media_router, prefix="/media", tags=["Media"])
