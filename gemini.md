# Deployment Rule

The deployment workflow is triggered under the following conditions:

```yaml
on:
  push:
    branches:
      - main
    paths:
      - 'easy_box_backend/**'
```
