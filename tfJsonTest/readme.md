# Terrform and using locals as configuration blocks
## What?
This is a test that shows configuration blocks using locals (Local Values
## Why?
Enabling an easily readable configuration block to provision your IAC through Terraform.
This was done for learning, thought it might be helpful for anyone startig on their tf journey.
## How?
- config block defined in root variables.tf
- main.tf uses Local Values (locals) and passes them as arguments to the resourceGroup module
- for_each in the resourceGroup module iterates through and creates resource groups from the instances keys
## Chalenges
Tags!!! While passing the tags first time is no issue, if they are not ignored (using the lifecycle block in the resourceGroup module) they will show as changes in the state whenever you plan/apply, not sure how to ensure these remain in state and only change when changed!!
## More?
- [Local Values](https://www.terraform.io/docs/configuration/locals.html)
- [modules](https://www.terraform.io/docs/configuration/modules.html)