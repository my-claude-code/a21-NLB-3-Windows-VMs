# a21 — 3 Windows Servers behind a Standard Load Balancer

Three Windows Server VMs (2019, 2022, 2025) behind an Azure **Standard** Load Balancer. Each VM also has its own public IP for RDP. A Custom Script Extension installs IIS on each VM; the home page shows the server's OS and private IP.

## Architecture

```
rg-nlb-windows-vms (Canada East)
  vnet-nlb (10.0.0.0/16) / subnet-vms (10.0.1.0/24)  nsg-vms (RDP 3389, HTTP 80)
  lb-windows (Standard) ── pip-lb ── :80 ──► backend pool (private IPs)
       ├── WinSrv2019  (pip-WinSrv2019)
       ├── WinSrv2022  (pip-WinSrv2022)
       └── WinSrv2025  (pip-WinSrv2025)
```

## Deploy

```bash
cp terraform.tfvars.example terraform.tfvars
# set subscription_id and admin_password
terraform init
terraform apply
```

- Browse to `http://<lb_public_ip>` — shows the OS name, server name and private IP of the server that answered.
- RDP to a VM: `mstsc /v:<vm_public_ip>` (user `azureuser` by default).

## Variables

| Variable | Default | Description |
|---|---|---|
| `subscription_id` | — | Azure subscription ID (**required**) |
| `admin_password` | — | VM admin password (**required**, no default) |
| `location` | `Canada East` | Azure region |
| `admin_username` | `azureuser` | VM admin username |
| `vm_size` | `Standard_B2s_v2` | VM size |

## Outputs

| Output | Description |
|---|---|
| `lb_public_ip` | Load balancer public IP |
| `vm_public_ips` | Public IP per VM (RDP) |
| `vm_private_ips` | Private IP per VM (backend pool) |
