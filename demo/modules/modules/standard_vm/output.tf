# The for expresstion below is detailed here
# azurerm_virtual_machine.standard has multiple objects and we need an expression to combine the password and vmname
# key (for key, vm ) refers to the specific instance, example azurerm_virtual_machine.standard["vm1"] would be the fist instance
# for is iterating through all keys in azurerm_virtual_machine.standard and returning the and returns (:) the key as a result
# the key can now be accessed using [key]
# vm (for key, vm) is the value of the key, azurerm_virtual_machine.standard["key"].value
# 

output "vm_details" {
  value = { for key, vm in azurerm_virtual_machine.standard : key => {  
    name = vm.name
    pass = random_password.password[key].result
    }
  }
}
