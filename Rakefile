require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"

# Change your GitHub reponame
GITHUB_REPONAME = "richardp2/richardp2.github.io"
BITBUCKET_REPO = "richardp2/personal-website"


desc "Build and preview the site"
task :preview => [:clean] do
  puts "## Building a preview of the site"
  pids = [
    spawn("bundle exec jekyll serve --drafts")
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
  

desc "Build the site ready for deployment"
task :build => [:clean] do
  puts "## Generate the Jekyll site files"
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
  puts "## Build complete"
end


desc "Generate and deploy blog to master"
task :deploy, [:message] => [:commit, :push, :build] do |t, args|
  args.with_defaults(:message => "Site updated at #{Time.now.utc}")
  
  puts "## Push built site to master branch"  
  Dir.mktmpdir do |tmp|
    # Clone the master branch into a temporary directory"
    system "git clone git@github.com:#{GITHUB_REPONAME}.git -b master #{tmp}"
    
    # Delete all files in the temporary directory to ensure deleted file are removed"
    rm_rf "#{tmp}/*"
    
    # Copy the build site to the temporary directory
    cp_r "_site/.", tmp
    
    # Store the current working directory for latere
    pwd = Dir.pwd
    
    # Change to the temporary directory
    Dir.chdir tmp
    
    # Add unstaged files, commit them, add the additional repository at Bitbucket and push to origin
    system "git add -A"
    system "git commit -m #{args[:message].inspect}"
    system "git remote set-url --add origin git@bitbucket.org:#{BITBUCKET_REPO}.git"
    system "git push origin master"
    
    # Change back to the previous working directory
    Dir.chdir pwd
  end
  
  puts "\nSite Published and Deployed to GitHub"
  puts "\nHave a nice day :-)"
end
  
# The following task was adapted from one written by Shane Burkhart  
# Source: http://www.shaneburkhart.me/2013/12/07/rake-task-to-publish-drafts-in-jekyll.html   
desc "Publish draft posts and update the date field"  
task :publish, [:file] do |t, args|
  require "time"
  require 'yaml'
  
  if args[:file]
    file = "_drafts/#{args[:file]}"
    text = File.read(file)
    time = Time.now.iso8601.gsub!('T', ' ')
    text.gsub!(/^date.*$/, "date: #{time}")
    today = Time.now.strftime("%Y-%m-%d")
    post_name = file.split("/").last
    dest = "_posts/#{today}-#{post_name}"
    File.open(dest, 'w') {|f| f.write(text) }
    puts "Published file #{post_name}"
    dest = "../perry-online/_posts/#{today}-#{post_name}"
    data = YAML::load_file file
    if data['permalink']
      permalink = data['permalink']
    else
      permalink = '/'
      data['categories'].each do |category|
        permalink += "#{category.downcase!}/"
      end
      permalink += "#{args[:file][0..-4]}/"
    end
      if data['author']
        author = data['author']
      else
        author = 'richard'
      end
    File.open(dest, 'w') {|f| 
      f.write("---") 
      f.write("\n")
      f.write("blog: richard")
      f.write("\n")
      f.write("date: #{time}")
      f.write("\n")
      f.write("title: \"#{data['title']}\"")
      f.write("\n")
      f.write("author: #{author}")
      f.write("\n")
      f.write("permalink: #{permalink}")
      f.write("\n")
      f.write("---") 
    }
    File.delete(file)
    puts "Deleted draft file #{post_name}"
  else
    puts "Incorrect usage of the :publish task"
    puts "\n\tUsage:"
    puts "\trake publish[draft-post.md]"
    puts "\nPlease try again"
  end
end

