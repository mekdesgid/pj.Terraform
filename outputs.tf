output "db_password" {
  value       = azurerm_linux_virtual_machine.DB-VM.admin_password
  description = "P@ssw0rd1234!"
  sensitive = true
}

