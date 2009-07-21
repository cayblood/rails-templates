# remove tmp dirs
run "rmdir tmp/{pids,sessions,sockets,cache}"

# remove unnecessary stuff
run "rm README log/*.log public/index.html public/images/rails.png"

# keep empty dirs
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")

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

# rcov rake tasks
file 'lib/tasks/rcov.rake',
%q{require 'cucumber/rake/task'
require 'spec/rake/spectask'
 
namespace :rcov do
  Cucumber::Rake::Task.new(:cucumber) do |t|    
    t.rcov = true
    t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/,features\/ --aggregate coverage.data}
    t.rcov_opts << %[-o "coverage"]
  end
 
  Spec::Rake::SpecTask.new(:rspec) do |t|
    t.spec_opts = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = lambda do
      IO.readlines("#{RAILS_ROOT}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
  end
 
  desc "Run both specs and features to generate aggregated coverage"
  task :all do |t|
    rm "coverage.data" if File.exist?("coverage.data")
    Rake::Task["rcov:cucumber"].invoke
    Rake::Task["rcov:rspec"].invoke
  end
end
}

# copy sample database config
run "cp config/database.yml config/example_database.yml"

# gems
gem 'rspec', :lib => 'spec'
gem 'rspec-rails', :lib => 'spec/rails'
gem 'cucumber'
rake "gems:install", :sudo => true
rake "gems:build", :sudo => true
run "rm -f log/*.log", :sudo => true # delete log to avoid ownership warnings
rake "gems:unpack"

# remove test dir
run "rm -rf test"

# generate
generate :rspec
generate :cucumber

# rake tasks
rake 'db:schema:dump'

# set up git
git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"
