# config valid only for Capistrano 3.1
lock '3.1.0'

#=> アプリケーション名
set :application, 'sample_app'
 #> Version管理
set :scm, :git
#=> githubのurl。プロジェクトのgitホスティング先を指定する
set :repo_url, 'git@github.com:KoganezawaRyouta/sample_app.git'
set :branch, 'master'
# :info or :debug
set :log_level, :debug
#> 5リリース分保持しておく。
set :keep_releases, 5

# sharedに下記のディレクトリを生成し、currentにシンボリックリンクを張る
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets bundle public/system public/assets}
set :format, :pretty
set :use_sudo, false #=> defaultではtrue

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
namespace :local do
  task :update do
    run_locally do
      execute "git pull origin master"
    end
  end
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  # after :publishing, :restart
  after 'deploy:publishing', 'deploy:restart'

#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
#    end
#  end
end
