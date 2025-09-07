from sqladmin.authentication import AuthenticationBackend
from starlette.requests import Request
from starlette.responses import RedirectResponse

from . import crud
from .auth_utils import verify_password
from .database import SessionLocal

class AdminAuth(AuthenticationBackend):
    async def login(self, request: Request) -> bool:
        form = await request.form()
        email, password = form["username"], form["password"]

        db = SessionLocal()
        user = crud.get_user_by_email(db, email=email)
        db.close()

        if not user or not verify_password(password, user.hashed_password):
            return False

        # You can store any data in the session
        request.session.update({"user_id": user.id})

        return True

    async def logout(self, request: Request) -> bool:
        request.session.clear()
        return True

    async def authenticate(self, request: Request) -> bool:
        return "user_id" in request.session

import os
from dotenv import load_dotenv

load_dotenv()

authentication_backend = AdminAuth(secret_key=os.getenv("SECRET_KEY"))
