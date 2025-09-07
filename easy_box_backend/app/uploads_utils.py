from fastapi import UploadFile
from sqlalchemy.orm import Session
import cloudinary
import cloudinary.uploader
from . import crud, schemas

def save_upload_file(file: UploadFile) -> str:
    """Saves an uploaded file to Cloudinary and returns its secure URL path."""
    # The upload function automatically uses the configuration set in main.py
    # The file object from UploadFile is accessed via .file
    upload_result = cloudinary.uploader.upload(file.file, folder="easy_box_products")
    return upload_result.get("secure_url")

def save_upload_file_and_update_product(db: Session, product_id: int, file: UploadFile) -> crud.models.Product:
    """Saves a file to Cloudinary and updates the image_url for an existing product."""
    image_url = save_upload_file(file)
    updated_product_data = schemas.ProductUpdate(image_url=image_url)
    return crud.update_product(db=db, product_id=product_id, product=updated_product_data)
