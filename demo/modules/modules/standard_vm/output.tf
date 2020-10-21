# output "vm_name" {
#     value = zipmap(
#         [for v in azurerm_virtual_machine.standard : v.name],
#         [for p in random_password.password : p.result])
# }

output "vm_details" {
  value = { for key, vm in azurerm_virtual_machine.standard : key => {
    name = vm.name
    pass = random_password.password[key].result
    }
  }
}
