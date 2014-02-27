#!/bin/sh
cd ~/workspace/source/
git add -A
git commit -aF changes
git push origin source
bundle exec jekyll build
cd ~/workspace/master/
git add -A
git commit -aF ../source/changes/
git push origin master
rsync -azh --progress --delete --exclude ".*" . perryon1@sftp.perry-online.me.uk:~/public_html/bGbDmSuXlg2MKV5PrIpJ/jekyll
cd ~/workspace/source/