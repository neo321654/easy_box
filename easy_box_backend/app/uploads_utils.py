import shutil
import uuid
from fastapi import UploadFile
from sqlalchemy.orm import Session
from . import crud, schemas


def save_upload_file_and_update_product(db: Session, product_id: int, file: UploadFile) -> crud.models.Product:
    # Generate a unique filename
    ext = file.filename.split('.')[-1]
    unique_filename = f"{uuid.uuid4()}.{ext}"
    file_path = f"uploads/{unique_filename}"

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    image_url = f"/images/{unique_filename}"
    updated_product_data = schemas.ProductUpdate(image_url=image_url)

    return crud.update_product(db=db, product_id=product_id, product=updated_product_data)
