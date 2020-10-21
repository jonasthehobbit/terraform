# The for expresstion below is detailed here
# for each key and value in azurerm_virtual_machine.standard return the key and create a new object
# with values name whcih will equak value.name 
# and passw which equals random_password.password[key].result

output "vm_details" {
  value = { for key, value in azurerm_virtual_machine.standard : key => {  
    name = value.name
    pass = random_password.password[key].result
    }
  }
}
