output "lb_public_ip" {
  description = "Browse to http://<ip> — each refresh may land on a different server"
  value       = azurerm_public_ip.lb.ip_address
}

output "vm_public_ips" {
  description = "RDP to each VM — mstsc /v:<ip>"
  value       = { for k, v in local.vms : v.name => azurerm_public_ip.vm[k].ip_address }
}

output "vm_private_ips" {
  description = "Private IPs registered in the load balancer backend pool"
  value       = { for k, v in local.vms : v.name => azurerm_network_interface.vm[k].private_ip_address }
}
