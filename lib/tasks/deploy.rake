# lib/tasks/deploy.rake
define_method(:`) {|command| puts "$ #{command}" } if ENV["DRYRUN"]

desc "Deploy application to production server"
task :deploy => %w[
  deploy:precompile
  deploy:push
  deploy:migrate
  deploy:tag
]

namespace :deploy do
  desc "Compile assets and git commit public/assets"
  task :precompile do
    puts
    puts "Compile assets to public/assets/"
    puts `RAILS_ENV=production rake assets:precompile`
    puts `git add public/assets`
    puts `git commit -m "Update public/assets/"`
  end

  desc "Push code to production server"
  task :push do
    puts
    puts "Migrate the database"
    Bundler.with_clean_env do
      puts `heroku run rake db:migrate --app nsg-future-commynity`
    end
    puts "Push Heroku Goo!"
    puts `git push heroku master`
  end

  desc "Mark a git tag to remember release version"
  task :tag do
    name = "release-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    puts
    puts "Mark a git tag to remember release version"
    puts "Tagging release as [#{name}]"
    puts `git tag -a #{name} -m "Tagged release"`
    puts `git push --tags heroku`
  end

  desc "Setup environments"
  task :setup => %w[
    deploy:setup:addons
    deploy:setup:env
  ]

  namespace :setup do
    desc "Setup addons"
    task :addons do
      puts
      puts "Setup addons"
      puts `heroku addons:add memcache`
    end

    desc "Setup ENV from .env"
    task :env do
      vals = File.read(".env").gsub("\n", " ")
      puts
      puts "Setup ENV from .env"
      puts `heroku config:add #{vals}`
    end
  end
end