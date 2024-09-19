# Установка Terraform
Заходим на сайт https://www.terraform.io/downloads.html

Берем ссылку на нужный дистрибутив, идем на ВМ, скачиваем
```
wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_386.zip
apt install p7zip-full
7z e архив
```

Руками перемещаем бинарник в папку /bin


Команды Terraform
```bash
terraform init - скачал провайдер
terraform plan
terraform apply
terraform show
terraform destroy
```