resource "google_storage_bucket" "this" {
  name                        = var.bucket_name
  location                    = var.location
  storage_class               = var.storage_class
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.uniform_bucket_level_access
}

resource "google_storage_bucket_iam_binding" "role-binding" {
  bucket  = google_storage_bucket.this.name
  role    = var.role
  members = [ 
    "allAuthenticatedUsers"
  ]
}
