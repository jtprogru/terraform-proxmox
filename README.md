# terraform-proxmox

Разворачивание VM с помощью Terraform из имеющихся шаблонов

Перед запуском ознакомиться с [variables.tf](variables.tf).

Количество серверов каждой группы задается индивидуально в файле с группой серверов в параметре `count`. Пример:

```ini
count       = 2
```

Сервер на который будет выполняться разворачивание инфраструктуры задается в файле `variables.tf` в переменной `proxmox_target_node`.

## Usage
```bash
# Склонировать репу
git clone https://github.com/jtprog/terraform-proxmox.git
# Перейти в нее (Кэп)
cd terraform-proxmox
# Проинициализировать
terraform init
# Проверить количество серверов на добавление/удаление и их параметры
terraform plan
# Если всё OK, применить инфраструктуру
terraform apply
```

## Result
После запуска команды `terraform apply` будет развернуто 15 серверов (при значениях по дефолту). В директории `ansible` будет сформирован файлик `hosts.ini`, в котором будет список всех серверов с доступом для Ansible. Его можно переносить в проектный репозиторий.

## TODO...
- [ ] TODO: Вытащить секреты в... куда-то. Видимо стоит развернуть Hashicorp Vault для таких вещей;
- [ ] TODO: Причесать репозиторий;
- [ ] TODO: Где-то храненить файлы состояний инфраструктуры `terraform.tfstate` и `terraform.tfstate.backup`... Hashicorp Vault;
- [ ] TODO: Доработать `cloud-init.yaml` до вменяемого состояния и сдружить с terraform'ом;
- [ ] TODO: Запилить статейку по данной теме;

## Links

- [Подготовка Cloud-Init шаблона](https://norocketscience.at/deploy-proxmox-virtual-machines-using-cloud-init/);
- [Деплой из подготовленного шаблона с помощью Terraform](https://norocketscience.at/provision-proxmox-virtual-machines-with-terraform/);
