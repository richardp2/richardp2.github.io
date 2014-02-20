#!/bin/sh
cd ~/workspace/richardp2.github.io/
git add -A
git commit -aF changes
git push origin master
jekyll build
rsync -az --delete _site/ perryon1@sftp.perry-online.me.uk:~/public_html/bGbDmSuXlg2MKV5PrIpJ/jekyll
