#!/bin/bash
brew install git

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

brew tap hashicorp/tap
brew update
brew install hashicorp/tap/terraform

brew install kubectl

brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
