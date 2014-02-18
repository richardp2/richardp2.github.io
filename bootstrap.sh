sudo -y apt-get update
sudo -y apt-get install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev curl git 
\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.0.0
sudo gem install bundler jekyll-import
cd /vagrant
sudo bundle install
