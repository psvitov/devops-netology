## variables.tf

variable "yc_token" {
    description = "ID Yandex.Token"
    default = "<OAuth-токен ЯО>"
    sensitive = true
}

variable "yc_cloud_id" {
    description = "ID Yandex.Cloud"
    default = "<Идентификатора облака ЯО>"
    sensitive = true
}

variable "yc_region_a" {
    description = "Region Zone A"
    default = "<Зона доступности>"
}
