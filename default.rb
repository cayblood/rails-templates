############## plugin commands #################
plugin 'rspec', :git => "git://github.com/dchelimsky/rspec.git", :submodule => true
plugin 'rspec-rails', :git => "git://github.com/dchelimsky/rspec-rails.git", :submodule => true
plugin 'factory_girl', :git => "git://github.com/thoughtbot/factory_girl.git", :submodule => true
plugin 'cucumber', :git => "git://github.com/aslakhellesoy/cucumber.git", :submodule => true

############## generate commands #################
generate("rspec")

##############  commands #################
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
file '.gitignore', <<-END
  .DS_Store
  log/*.log
  tmp/**/*
  config/database.yml
  db/*.sqlite3
END
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
