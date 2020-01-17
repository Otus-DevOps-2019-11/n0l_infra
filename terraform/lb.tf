# Пример создания балансера в googe cloud и использованием terraform
# 1. создаем группу инстансов, на нее мы будем перенаправлять трафик
# есть два типа групп  managed и unmanaged, от типагруппы зависят параметры, которые нужно указывать
# https://cloud.google.com/community/tutorials/modular-load-balancing-with-terraform
# https://www.terraform.io/docs/providers/google/r/compute_global_forwarding_rule.html
# https://cloud.google.com/load-balancing/docs/https/
# в данном случае используется unmanaged

resource "google_compute_instance_group" "ex-8-instance-group" {
  name        = "ex-8-instance-group"
  description = "Terraform test instance group"

  instances = [
    google_compute_instance.app.self_link,
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "us-central1-f"
}

# создаем health-check для проверки состояния наших инстансов в группе
resource "google_compute_health_check" "ex-8-health-check" {
  name = "ex-8-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = 9292
    request_path       = "/"
  }
}

# в разделе loadbalansing создается бекенд, служит ссылкой с будущего балансера на нашу группу инстансов
resource "google_compute_backend_service" "default" {
  name          = "backend-service"
  health_checks = [google_compute_health_check.ex-8-health-check.self_link]
  backend {
  group = google_compute_instance_group.ex-8-instance-group.self_link
  }
}

# создаем балансировщик нагрузки
resource "google_compute_url_map" "urlmap" {
  name        = "urlmap"
  description = "a description"
  default_service = google_compute_backend_service.default.self_link
}

# https://cloud.google.com/load-balancing/docs/target-proxies
# создаем целевой прокси сервер
resource "google_compute_target_http_proxy" "default" {
  name    = "test-proxy"
  url_map = google_compute_url_map.urlmap.self_link
}

# добавляем правила обработки трафика
resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule"
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
}


