require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"

# Change your GitHub reponame
GITHUB_REPONAME = "richardp2/richardp2.github.io"


desc "Build and preview the site"
task :preview => [:clean] do
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
  
  
desc 'Delete generated _site files'
task :clean do
  puts "## Cleaning up build folder (if it exists)"
  status = system "rm -rf _site"
end
  
  
desc "Commit the source branch of the site"
task :commit do
  puts "## Adding unstaged files"
  status = system "git add -A > /dev/null"
  puts status ? "Succeeded" : "Failed"
  puts "\n## Committing changes with commit message from file 'changes'"
  status = system "git commit -aF changes"
  puts status ? "Succeeded" : "Failed"
end
  
desc "Push source file commits up to origin"
task :push do
  puts "## Pushing commits to origin"
  status = system "git push origin source"
  puts status ? "Succeeded" : "Failed"
end
  

desc "Generate blog files"
  task :generate => [:clean] do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
end


desc "Generate and publish blog to master"
task :publish => [:generate] do
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp
    
    pwd = Dir.pwd
    Dir.chdir tmp
    
    system "git init"
    system "git add ."
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m #{message.inspect}"
    system "git remote add origin git@github.com:#{GITHUB_REPONAME}.git"
    system "git push origin master --force"
    
    Dir.chdir pwd
  end
end
  
  desc "Deploy the source and master to GitHub"
  task :deploy => [:commit, :push, :publish] do
    puts "\nSite Published and Deployed to GitHub"
    puts "\nHave a nice day :-)"
  end




namespace :rsync do
  desc "--dry-run rsync"
  task :dryrun do
      puts "\## Publishing Site (as a Dry Run)"
      status = system('rsync ./_site/ -avhe ssh --exclude ".*" --dry-run --delete perryon1@sftp.perry-online.me.uk:~/public_html/bGbDmSuXlg2MKV5PrIpJ/jekyll')
      puts status ? "Success" : "Failed"
    end
  desc "rsync"
    task :live do
      system('rsync ./_site/ -avhe ssh --exclude ".*" --delete perryon1@sftp.perry-online.me.uk:~/public_html/bGbDmSuXlg2MKV5PrIpJ/jekyll')
      Rake::Task["clean"].invoke
    end
end