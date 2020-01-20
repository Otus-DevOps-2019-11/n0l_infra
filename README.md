# n0l_infra
n0l Infra repository
## Ex.5
## alias for connect though bastion
alias  someinternalhost="ssh -i ~/.ssh/n0l -A -J n0l@35.209.112.226 n0l@10.128.0.3"

bastion_IP = 35.209.112.226
someinternalhost_IP = 10.128.0.3

## Ex.6
## deploy app and create startup script

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
## Create image with packer
1. Создан образ с предустановленными пакетами mongodb и ruby
2. Разобран кейс с параметризацией через файл variables.json
3. Создан образ bake (immutable.json) c уже установленным и настроенным кодом приложения
4. create-redditvm.sh - позволяет из командной строки запустить новый  инстанс

gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image=reddit-full-1578572829 \
--machine-type=f1-micro \
--tags puma-server \
--zone=us-central1-f \
--preemptible \

## Ex.8
Задание со *: 
1. Для добавления нескольких ssh ключей в метаданные всего проекта, их нужно записывать в одну строку без пробелов. (пример ниже)
2. Если через web поменять конфигурацию, затем выполнить terraform apply, то он затрет измения выполненные через web

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file("/Users/xxx/.ssh/appuser1.pub")}appuser2:${file("/Users/xxx/.ssh/appuser2.pub")}"
Задание со **:
1. Создан и проверен балансировщик нагрузки, описание добавлено в файл lb.tf
2. Добавлена выходная переменная
3. Не разобрался с параметром count (будет в следующей лекции)

 
## Ex.9
1. Работа и существующей инфраструктурой, сделанной не средствами терраформ и её импорт в терраформ на примете фаервола
2. Ссылку в одном ресурсе на атрибуты другого тераформ
понимает как зависимость одного ресурса от другого. Это влияет
на очередность создания и удаления ресурсов при применении
изменений.
3. Разделение проекта на несколько виртуальных машин. Создали два конфига: для БД и для приложения
4. Работа с модулями
5. Создание идентичных окружений stage и prod
6. Работа с реестром модулей terraform registry
 
