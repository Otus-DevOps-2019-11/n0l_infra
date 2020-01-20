variable public_key_path {
description = "Path to the public key used to connect to instance"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-1579431547"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "us-central1-f"
}
