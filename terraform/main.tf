terraform {
  # Версия terraform
  required_version = "0.12.19"
}
provider "google" {
  # Версия провайдера
  version = "2.15"
  # ID проекта
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "f1-micro"
  zone         = var.zone
  tags         = ["reddit-app"]
  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = "n0l"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }
  provisioner "file" {
    source      = "./files/puma.service"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }
  metadata = {
    # путь до публичного ключа
    ssh-keys = "n0l:${file(var.public_key_path)}"
  }
  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app"]
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "n0l:${file(var.public_key_path)}appuser1:${file("/Users/oleg-nov/.ssh/appuser1.pub")}appuser2:${file("/Users/oleg-nov/.ssh/appuser2.pub")}"
  }
}

