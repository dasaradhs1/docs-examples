// Forwarding rule for Internal Load Balancing
resource "google_compute_forwarding_rule" "default" {
  provider = "google-beta"
  name                  = "website-forwarding-rule-${local.name_suffix}"
  region                = "us-central1"
  load_balancing_scheme = "INTERNAL"
  backend_service       = "${google_compute_region_backend_service.backend.self_link}"
  all_ports             = true
  allow_global_access   = true
  network               = "${google_compute_network.default.name}"
  subnetwork            = "${google_compute_subnetwork.default.name}"
}
resource "google_compute_region_backend_service" "backend" {
  provider = "google-beta"
  name                  = "website-backend-${local.name_suffix}"
  region                = "us-central1"
  health_checks         = ["${google_compute_health_check.hc.self_link}"]
}
resource "google_compute_health_check" "hc" {
  provider = "google-beta"
  name               = "check-website-backend-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}
resource "google_compute_network" "default" {
  provider = "google-beta"
  name = "website-net-${local.name_suffix}"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "default" {
  provider = "google-beta"
  name          = "website-net-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = "${google_compute_network.default.self_link}"
}
