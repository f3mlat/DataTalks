terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.17.0"
    }
  }
}

provider "google" {
  # Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  # credentials = 
  project = "dezoomcamp2025-449018"
  region  = "us-central1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name     = "dezoomcamp2025-449018-datalake-bucket"
  location = "US"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "ny_taxi_dataset"
  project    = "dezoomcamp2025-449018"
  location   = "US"
}