terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  zone      = var.yc_region
}

resource "yandex_resourcemanager_folder" "folder1" {
  cloud_id    = var.yc_cloud_id
  name        = "security"
  description = "Cloud Security"
}

resource "yandex_iam_service_account" "sa" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name = "s-account"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_kms_symmetric_key" "key-a" {
  folder_id = "${yandex_resourcemanager_folder.folder1.id}"
  name              = "key-secure"
  description       = "KMS Cloud key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = true
  }
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "cloudsec" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "secure-140223"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "foto-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "secure-140223"
  key        = "foto"
  source     = "/home/devops/Homeworks/15_3/15_3_1.png"
}

resource "yandex_storage_object" "html-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "secure-140223"
  key        = "html"
  source     = "/home/devops/Homeworks/15_3/index.html"
}
