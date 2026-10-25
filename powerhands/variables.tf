variable "domain_name" {
  description = "Apex domain for powerhands, registered with Cloudflare Registrar"
  type        = string
}

variable "frontend_lb_ip" {
  description = "Static IP of the GCP frontend load balancer serving the client"
  type        = string
}
