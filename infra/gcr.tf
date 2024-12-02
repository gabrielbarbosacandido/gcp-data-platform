resource "google_container_registry" "this" {
  project  = var.project_id
  location = var.region
}

resource "google_storage_bucket_iam_member" "this" {
  for_each = toset(var.gcr_members)

  bucket = google_container_registry.registry.id
  role   = gcr_role
  member = each.value
}
