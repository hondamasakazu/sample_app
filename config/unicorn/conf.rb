# for ES2 or Local
if ENV['RAILS_ENV'] == "development"
  #proj_root_dir = File.expand_path("../../../../", __FILE__)
  #worker_processes 4
  #preload_app true
  #listen      "/tmp/unicorn/future.commynity.com/sockets/universe.sock"
  #pid         "#{proj_root_dir}/sample_app/tmp/pids/unicorn.pid"
  #stderr_path "#{proj_root_dir}/sample_app/log/unicorn.log"
  #stdout_path "#{proj_root_dir}/sample_app/log/unicorn.log"

  # app_path = '/var/www/capistrano.test'
  # app_shared_path = "#{app_path}/shared"
  # 実態は symlink。SIGUSR2 を送った時にこの symlink に対して
  # Unicorn のインスタンスが立ち上がる
  # working_directory "#{app_path}/current/"

  # worker_processes 4
  # ダウンタイムをなくす
  # preload_app true
  # listen "#{app_shared_path}/tmp/sockets/unicorn.sock"
  # pid "#{app_shared_path}/tmp/pids/unicorn.pid"
  # stdout_path "#{app_shared_path}/log/unicorn.stdout.log"
  # stderr_path "#{app_shared_path}/log/unicorn.stderr.log"


  app_path = '/var/www/capistrano.test'
  app_shared_path = "#{app_path}/shared"
  worker_processes 5
  # 実態は symlink。
  # SIGUSR2 を送った時にこの symlink に対して
  # Unicorn のインスタンスが立ち上がる
  working_directory "#{app_path}/current/"
  listen "#{app_shared_path}/tmp/sockets/unicorn.sock"
  stdout_path "#{app_shared_path}/log/unicorn.stdout.log"
  stderr_path "#{app_shared_path}/log/unicorn.stderr.log"
  pid "#{app_shared_path}/tmp/pids/unicorn.pid"
  # ダウンタイムをなくす
  preload_app true
  before_fork do |server, worker|
    defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

    old_pid = "#{ server.config[:pid] }.oldbin"
    unless old_pid == server.pid
      begin
        Process.kill :QUIT, File.read(old_pid).to_i
      rescue Errno::ENOENT, Errno::ESRCH
      end
    end
  end

  after_fork do |server, worker|
    defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  end




end

# for Heroku
if ENV['RAILS_ENV'] == "production"
  worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
  timeout 15
  preload_app true

  before_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
      Process.kill 'QUIT', Process.pid
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  after_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end
end