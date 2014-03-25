require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"

# Change your GitHub reponame
GITHUB_REPONAME = "richardp2/richardp2.github.io"
BITBUCKET_REPO = "richardp2/personal-website"


desc "Build and preview the site"
task :preview => [:build, :clean] do
  puts "## Building a preview of the site"
  pids = [
    spawn("jekyll serve -w")
  ]
  
  trap "INT" do
    Process.kill "INT", *pids
    puts "\n## Preview site shutdown"
    exit 1
  end
  
  loop do
    sleep 1
  end
end

desc 'Concatenate & minify the css & js files for the site'
task :build do
  puts "## Concatenating & minifying/uglifying css & js files"
  system "grunt"
end
  
desc 'Delete generated _site files'
task :clean do
  puts "## Cleaning up build folder (if it exists)"
  system "rm -rf _site"
end
  
  
desc "Commit the source branch of the site"
task :commit do
  puts "## Adding unstaged files"
  system "git add -A > /dev/null"
  puts "\n## Committing changes with commit message from file 'changes'"
  system "git commit -aF changes"
end
  
desc "Push source file commits up to origin"
task :push do
  puts "## Check there is nothing to pull from origin"
  system "git pull"
  puts "## Pushing commits to origin"
  system "git push origin source"
end
  

desc "Generate blog files"
task :generate => [:clean] do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
end


desc "Generate and deploy blog to master"
task :deploy, [:message] => [:build, :commit, :push, :generate] do |t, args|
  args.with_defaults(:message => "Site updated at #{Time.now.utc}")
  
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp
    
    pwd = Dir.pwd
    Dir.chdir tmp
    
    system "git init"
    system "git add ."
    system "git commit -m #{args[:message].inspect}"
    system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
    system "git remote set-url --add origin git@bitbucket.org:#{BITBUCKET_REPO}.git"
    system "git push origin master --force"
    
    Dir.chdir pwd
  end
  
  puts "\nSite Published and Deployed to GitHub"
  puts "\nHave a nice day :-)"
end
