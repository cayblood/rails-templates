# remove tmp dirs
run "rmdir tmp/{pids,sessions,sockets,cache}"

# remove unnecessary stuff
run "rm README log/*.log public/index.html public/images/rails.png"

# keep empty dirs
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")

# init git repo
git :init

# basic .gitignore file
file '.gitignore', 
%q{log/*.log
log/*.pid
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
.DS_Store
doc/api
doc/app
config/database.yml
autotest_result.html
coverage
public/javascripts/*_[0-9]*.js
public/stylesheets/*_[0-9]*.css
public/attachments
}

# copy sample database config
run "cp config/database.yml config/example_database.yml"

# gems
gem 'rspec', :lib => 'spec'
gem 'rspec-rails', :lib => 'spec/rails'
gem 'cucumber'
rake "gems:install", :sudo => true
run "rm -f log/*.log", :sudo => true # delete log to avoid ownership warnings
rake "gems:unpack"

# remove test dir
run "rm -rf test"

# generate
generate :rspec
generate :cucumber

# set up git
git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"