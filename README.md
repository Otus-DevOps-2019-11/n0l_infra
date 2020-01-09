# n0l_infra
n0l Infra repository
Ex.5
#alias for connect though bastion
alias  someinternalhost="ssh -i ~/.ssh/n0l -A -J n0l@35.209.112.226 n0l@10.128.0.3"

bastion_IP = 35.209.112.226
someinternalhost_IP = 10.128.0.3

Ex.6
#deploy app and create startup script

For run startup script, durin create VM. You should in the gcloud console add option --metadata-from-file startup-script=path/to/file

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
  --metadata-from-file startup-script=path/to/file

#Create firewall rull from command line
gcloud compute firewall-rules create default-puma-server1  --allow=tcp:9292   --source-ranges=0.0.0.0/0   --target-tags=puma-server

testapp_IP = 35.222.34.66
testapp_port = 9292


