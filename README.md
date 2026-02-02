# Infraestrutura AWS

## Setup rápido
```bash
# 1. Clone
git clone https://github.com/gquadros-dev/terraform-infra-learning.git
cd infra-aws

# 2. Configure variáveis
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars  # Edite com suas senhas

# 3. Rode
terraform init
terraform plan
terraform apply
```
