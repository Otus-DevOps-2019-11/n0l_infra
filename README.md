# n0l_infra
n0l Infra repository
## Ex.5
### alias for connect though bastion
alias  someinternalhost="ssh -i ~/.ssh/n0l -A -J n0l@35.209.112.226 n0l@10.128.0.3"

bastion_IP = 35.209.112.226
someinternalhost_IP = 10.128.0.3

## Ex.6
### deploy app and create startup script

For run startup script, durin create VM. You should in the gcloud console add option --metadata-from-file startup-script=path/to/file

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
  --metadata-from-file startup-script=path/to/file

### Create firewall rull from command line
gcloud compute firewall-rules create default-puma-server1  --allow=tcp:9292   --source-ranges=0.0.0.0/0   --target-tags=puma-server

testapp_IP = 35.222.34.66
testapp_port = 9292

## Ex.7
### Create image with packer
 - Создан образ с предустановленными пакетами mongodb и ruby
 - Разобран кейс с параметризацией через файл variables.json
 - Создан образ bake (immutable.json) c уже установленным и настроенным кодом приложения
 - create-redditvm.sh - позволяет из командной строки запустить новый  инстанс
 - Команда для создания образа "./packer build -var-file variables.json db.json"
 
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image=reddit-full-1578572829 \
--machine-type=f1-micro \
--tags puma-server \
--zone=us-central1-f \
--preemptible \

## Ex.8
### Задание со *: 
 - Для добавления нескольких ssh ключей в метаданные всего проекта, их нужно записывать в одну строку без пробелов. (пример ниже)
 - Если через web поменять конфигурацию, затем выполнить terraform apply, то он затрет измения выполненные через web

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file("/Users/xxx/.ssh/appuser1.pub")}appuser2:${file("/Users/xxx/.ssh/appuser2.pub")}"
### Задание со **:
 - Создан и проверен балансировщик нагрузки, описание добавлено в файл lb.tf
 - Добавлена выходная переменная
 - Не разобрался с параметром count (будет в следующей лекции)

 
## Ex.9
 - Работа и существующей инфраструктурой, сделанной не средствами терраформ и её импорт в терраформ на примете фаервола
 - Ссылку в одном ресурсе на атрибуты другого тераформ
понимает как зависимость одного ресурса от другого. Это влияет
на очередность создания и удаления ресурсов при применении
изменений.
 - Разделение проекта на несколько виртуальных машин. Создали два конфига: для БД и для приложения
 - Работа с модулями
 - Создание идентичных окружений stage и prod
 - Работа с реестром модулей terraform registry


## Ex.10
### Введение в основные компоненты Ansible
 - Создали инвентори файл
 - поработали с группами хостов
 - познакомились с модулями
 - написали простой плейбук

Строчка PLAY RECAP
ok= -      сколько задачь выполнено
changed= - сколько задач произвели изменения на компе

### Задание со *
https://medium.com/@Nklya/%D0%B4%D0%B8%D0%BD%D0%B0%D0%BC%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B5-%D0%B8%D0%BD%D0%B2%D0%B5%D0%BD%D1%82%D0%BE%D1%80%D0%B8-%D0%B2-ansible-9ee880d540d6
Для работы с динамическим инвентори нужно написать скрипт, который на выходе выдает json формата как в статье
Скрипт dynamic-inventory.py -  ходит в gcp,  парсит   имена хостов и ip адреса и выдает форматированный  json 

## Ex.11
### Ansible работа с плейбуками
 - рассмотрели вырианты создания инфрструктуры с помощью плейбуков (один файл нужно задавать группы хостов к которым будет применяться этот файл через --limit и через теги --tags задания)
 - расмотрели вариант, в одном плейбуке лежит несколько сценариев (указывать нужно только теги, а нужные группы уже заложены в сценариях)
 - рассмотрели вариант с несколькими плейбуками (самый оптимальный)
 - переписал скрипт для создания динамического инвентори (теперь на выходе json c разбивкой пр группам)
 - Вместо shell скриптов в packer теперь используется ansible для устанловки пакетов

 - документация по модулям: https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html
 - документация по циклам: https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html
 - команда для запуска плейбука на хостах входящих в группу db выполняться только задачи с тегом app-tag (--check тестовый прогон плейбука): "ansible-playbook reddit_app.yml --check --tags app-tag  --limit db"
 - P.S. Пути в JSON-файлах корректны, билд образов нужно производить из корня репозитория
 - P.P.S. Для WSL может понадобиться задать еще пользователя "user": "appuser"
