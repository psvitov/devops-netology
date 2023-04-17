variable "yc_token" {
    description = "ID Yandex.Token"
    default = "y0_AgAAAAAARMfEAATuwQAAAADenXK2gMMEnMpiR9uptV4Qe44EV5sWrMw"
    sensitive = true
}

variable "yc_cloud_id" {
    description = "ID Yandex.Cloud"
    default = "b1g8fhcp9qmijeuurdt7"
    sensitive = true
}

variable "yc_region_a" {
    description = "Region Zone A"
    default = "ru-central1-a"
}

variable "master" {
    description = "Initial Master-node name"
    default = "master"
}

variable "masters_count" {
    description = "Quantity of master-node"
    default = 1
}

variable "node" {
    description = "Initial Worker-node name"
    default = "node"
}

variable "nodes_count" {
    description = "Quantity of worker-node"
    default = 3
}
