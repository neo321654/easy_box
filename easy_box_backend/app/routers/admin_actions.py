from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Request
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from .. import crud, deps
from ..uploads_utils import save_upload_file_and_update_product

router = APIRouter(
    prefix="/custom_admin",
    tags=["admin"],
    dependencies=[Depends(deps.get_current_admin)],
)

@router.get("/product/{product_id}/upload", response_class=HTMLResponse)
async def get_upload_form(request: Request, product_id: int, db: Session = Depends(deps.get_db)):
    product = crud.get_product(db, product_id=product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    html_content = f"""
    <html>
        <head>
            <title>Upload Image for {product.name}</title>
        </head>
        <body>
            <h1>Upload Image for {product.name} (SKU: {product.sku})</h1>
            <form action="/custom_admin/product/{product_id}/upload" method="post" enctype="multipart/form-data">
                <input type="file" name="file" accept="image/*">
                <input type="submit">
            </form>
        </body>
    </html>
    """
    return HTMLResponse(content=html_content)

@router.post("/product/{product_id}/upload")
async def handle_file_upload(request: Request, product_id: int, db: Session = Depends(deps.get_db), file: UploadFile = File(...)):
    product = crud.get_product(db, product_id=product_id)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    save_upload_file_and_update_product(db=db, product_id=product_id, file=file)

    # Redirect back to the product list in the admin panel
    return RedirectResponse(url=f"/admin/product/list", status_code=303)
