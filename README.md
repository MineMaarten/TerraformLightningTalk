# Set-up
## Azure
1. Create a storage account that will contain the Terraform state. 
    - Create a container called 'tfstate'.
    - Save the name name and access key of this storage account for later.
2. Create an app registration. 
    - You will need the client id later. 
    - Create a client secret and save this for later.
3. In the subscription you want to deploy resources in, make sure the app registration has at least 'Contributor' rights.

## Terraform
1. Open a powershell to the root of this repo.
2. Set-up environment variables to authenticate:
```
$env:ARM_TENANT_ID = "<tenant id of the subscription to deploy resources into>"
$env:ARM_SUBSCRIPTION_ID = "<subscription id of the subscription to deploy resources into>"
$env:ARM_ACCESS_KEY = "<storage account access key>"
$env:ARM_CLIENT_ID = "<app registration client id>"
$env:ARM_CLIENT_SECRET = "<app registration client secret>"
$env:TF_VAR_site_name= "<some unique name indicating your project/customer>" 
```

3. Run `terraform init -backend-config="storage_account_name=<storage account name>"`. This should result in 'Terraform has been successfully initialized'.
4. Run `terraform workspace new dev` to switch to the dev environment state.
5. Run `terraform plan --var-file .\variables_dev.tfvars.json -out changes`. Terraform will use the variables of this specific DTAP environment, and the current state of the resources, to calculate what needs to change. This is saved in a 'changes' file.
6. Run `terraform apply "changes"`. This will apply the proposed changes. 

To roll out a tst environment, simply run:
1. `terraform workspace new tst`, to switch to a clean state (prevents terraform wanting to destroy the dev environment to replace it)
2. `terraform plan --var-file .\variables_tst.tfvars.json -out changes`
3. `terraform apply "changes"`