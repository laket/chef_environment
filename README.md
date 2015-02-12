# chef_environment
このレポジトリはUbuntuインストール後に開発環境を構築するための、
レシピを格納するものです。

レシピは必須のベースレシピと開発対象言語で分割予定です。

まず、以下でchefをインストールしてください。
curl -L http://www.opscode.com/chef/install.sh | sudo bash

後にこのレポジトリをローカルにcloneし、
**localhost.jsonを編集した後に**
> sudo chef-solo -c solo.rb -j ./localhost.json
を実行してください。

