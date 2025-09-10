# Backend Rewrite Plan (Django + PostgreSQL)

This document outlines the steps to rewrite the backend for the Easy Box application using Django and PostgreSQL, with automated deployment.

## Phase 1: Analysis and Planning

-   [x] Create this plan document.
-   [x] Analyze the existing Flutter application to understand its requirements. (Inferred from backend analysis)
-   [x] Analyze the existing Django backend to understand the current data models, API endpoints, and business logic.
    -   [x] Review `api/models.py`
    -   [x] Review `api/views.py`
    -   [x] Review `api/serializers.py`
    -   [x] Review `api/urls.py`
-   [x] Analyze the deployment workflow in `.github/workflows/backend-deploy.yml`.

## Phase 2: Server Cleanup and Preparation

-   [x] Connect to the server via SSH. (Handled by workflow)
-   [x] Stop the current backend services (Docker containers). (Handled by workflow)
-   [x] Remove the old project files. (Handled by workflow)
-   [x] Uninstall old dependencies if necessary. (Handled by workflow)
-   [x] Clean up Docker (remove old containers, images, volumes). (Handled by workflow)

## Phase 3: New Backend Implementation

-   [x] Create a new Django project structure.
-   [x] Configure the project for PostgreSQL.
-   [x] Re-implement the Django models (`models.py`).
-   [x] Create and run database migrations.
-   [x] Re-implement the Django admin interface (`admin.py`).
-   [x] Re-implement the API serializers (`serializers.py`).
-   [x] Re-implement the API views (`views.py`).
-   [x] Re-implement the URL routing (`urls.py`).
-   [x] Add extensive logging and print statements for debugging.

## Phase 4: Deployment Automation

-   [x] Create a new `Dockerfile` for the new project.
-   [x] Create a new `docker-compose.yml` for production.
-   [x] Update the `.github/workflows/backend-deploy.yml` workflow.
    -   [x] Add steps to build the new Docker image.
    -   [x] Add steps to push the image to a registry (if needed).
    -   [x] Update the deployment script to use the new Docker Compose file.
    -   [x] Ensure environment variables (like database credentials) are correctly passed.

## Phase 5: Testing and Verification

-   [x] Trigger the deployment workflow.
-   [x] Monitor the deployment logs for errors.
-   [x] SSH into the server to verify the new containers are running.
-   [x] Test the API endpoints manually (e.g., using `curl`).
-   [x] Test the full application flow with the Flutter app.
-   [x] Review server logs for any runtime errors.
-   [x] Mark tasks as complete in this plan.
