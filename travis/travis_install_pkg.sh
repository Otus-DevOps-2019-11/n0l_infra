#!/bin/bash
sudo apt-get update
sudo apt-get install -y unzip curl python-pip
cd /tmp
curl -L -O https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip
curl -L -O https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip
curl -L -O https://github.com/terraform-linters/tflint/releases/download/v0.13.4/tflint_linux_amd64.zip

#sudo unzip -o -d /usr/local/bin/ "*.zip"
sudo unzip -o -d /usr/local/bin/ packer_1.5.1_linux_amd64.zip
sudo unzip -o -d /usr/local/bin/ terraform_0.12.9_linux_amd64.zip
sudo unzip -o -d /usr/local/bin/ tflint_linux_amd64.zip

rm *.zip

echo "packer: $(packer --version)"
terraform --version
tflint -v

pip install --user --upgrade pip
pip install --user ansible ansible-lint

