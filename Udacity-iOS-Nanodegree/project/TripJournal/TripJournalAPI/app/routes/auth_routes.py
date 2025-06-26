from datetime import timedelta

from fastapi import APIRouter, Depends, HTTPException, Request
from fastapi.security import OAuth2PasswordRequestForm

from app.auth import authenticate_user, create_access_token, get_password_hash
from app.database import get_db
from app.models import user as models
from app.schemas import auth as schemas
from app.utils import ACCESS_TOKEN_EXPIRE_MINUTES, RATE_LIMIT, limiter

router = APIRouter()


@router.post("/register", response_model=schemas.Token)
@limiter.limit(RATE_LIMIT)
async def create_new_user(
    request: Request, user: schemas.UserCreate, db=Depends(get_db)
):
    db_user = (
        db.query(models.User).filter(models.User.username == user.username).first()
    )
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    hashed_password = get_password_hash(user.password)
    db_user = models.User(username=user.username, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    login_form = OAuth2PasswordRequestForm(
        username=user.username, password=user.password
    )
    return await login_for_access_token(request, login_form, db)


@router.post("/token", response_model=schemas.Token)
@limiter.limit(RATE_LIMIT)
async def login_for_access_token(
    request: Request,
    form_data: OAuth2PasswordRequestForm = Depends(),
    db=Depends(get_db),
):
    user = authenticate_user(form_data.username, form_data.password, db)
    if not user:
        raise HTTPException(
            status_code=401,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return schemas.Token(access_token=access_token, token_type="bearer")
