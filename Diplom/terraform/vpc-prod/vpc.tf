resource "yandex_compute_instance_group" "prod-ig" {
  name               = "vpc-prod-ig"
  folder_id          = "${yandex_resourcemanager_folder.folder1.id}"
  service_account_id = "${yandex_iam_service_account.sa.id}"
  depends_on          = [yandex_resourcemanager_folder_iam_member.editor]
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8jvcoeij6u9se84dt5"
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.prod-net.id}"
      subnet_ids = ["${yandex_vpc_subnet.prod-subnet-a.id}", "${yandex_vpc_subnet.prod-subnet-b.id}", "${yandex_vpc_subnet.prod-subnet-c.id}"]
    }

    metadata = {
      ssh-keys = "devops:ssh-rsa AAAAB3NzaC1yc2E********************/ZITHZlVbTVaFNOPIOVRgNc7mRRQ4+3CbJIwYTumH0pJal7Rc6CeTXFEb35HeMoO0eyEzan4TSOfXvS4Q5Wutq8CRAbbdG7UwrUGcMeK0U6XAQguuxVcY5C7bGJ8c2y2In19fM0TpheLA1c1LZeX2BXJbIXTJM52Fsfo0s0t6pXPDLXx/2PkdeFdrMhUybJ5202SQXfbsElgDsVCfaEkWMm8gJfsIzMqLWEHrheFtfcbLIRzpBvEs2OZbK6Fofo7akYy5zkjvOrGaVy4u9YoFStkD2uCGOp8D8q3ADULYEunI+INVTdg/JtBRjYBw60ZH devops@DevOps"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_region_a, var.yc_region_b, var.yc_region_c]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion = 0
  }
}
