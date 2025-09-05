from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from sqlalchemy.orm import Session
from typing import List, Optional
import shutil

from .. import crud, models, schemas, deps
from ..uploads_utils import save_upload_file, save_upload_file_and_update_product

router = APIRouter(
    prefix="/products",
    tags=["products"],
    dependencies=[Depends(deps.get_current_active_user)],
    responses={404: {"description": "Not found"}},
)

@router.post("/", response_model=schemas.Product)
def create_product(
    db: Session = Depends(deps.get_db),
    name: str = Form(...),
    sku: str = Form(...),
    quantity: int = Form(...),
    location: Optional[str] = Form(None),
    file: Optional[UploadFile] = File(None)
):
    db_product = crud.get_product_by_sku(db, sku=sku)
    if db_product:
        raise HTTPException(status_code=400, detail="SKU already registered")
    
    image_url = None
    if file:
        image_url = save_upload_file(file)
        
    product_data = schemas.ProductCreate(
        name=name,
        sku=sku,
        quantity=quantity,
        location=location,
        image_url=image_url
    )
    
    return crud.create_product(db=db, product=product_data)

@router.get("/", response_model=List[schemas.Product])
def read_products(skip: int = 0, limit: int = 100, db: Session = Depends(deps.get_db)):
    products = crud.get_products(db, skip=skip, limit=limit)
    return products

@router.get("/{product_id}", response_model=schemas.Product)
def read_product(product_id: int, db: Session = Depends(deps.get_db)):
    db_product = crud.get_product(db, product_id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return db_product

@router.get("/sku/{sku}", response_model=schemas.Product)
def read_product_by_sku(sku: str, db: Session = Depends(deps.get_db)):
    db_product = crud.get_product_by_sku(db, sku=sku)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return db_product

@router.put("/{product_id}", response_model=schemas.Product)
def update_product(product_id: int, product: schemas.ProductUpdate, db: Session = Depends(deps.get_db)):
    db_product = crud.update_product(db, product_id=product_id, product=product)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return db_product

@router.delete("/{product_id}", response_model=schemas.Product)
def delete_product(product_id: int, db: Session = Depends(deps.get_db)):
    db_product = crud.delete_product(db, product_id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return db_product

@router.post("/{sku}/add_stock", response_model=schemas.Product)
def add_stock_to_product(sku: str, quantity: int, db: Session = Depends(deps.get_db)):
    db_product = crud.add_stock(db, sku=sku, quantity=quantity)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return db_product

@router.post("/{product_id}/upload-image", response_model=schemas.Product)
def upload_product_image(product_id: int, db: Session = Depends(deps.get_db), file: UploadFile = File(...)):
    db_product = crud.get_product(db, product_id=product_id)
    if db_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return save_upload_file_and_update_product(db=db, product_id=product_id, file=file)