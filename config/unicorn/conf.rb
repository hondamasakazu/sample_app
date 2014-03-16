# for ES2 or Local
if ENV['RAILS_ENV'] == "development"
  proj_root_dir = File.expand_path("../../../../", __FILE__)
  worker_processes 4
  preload_app true
  listen      "/tmp/unicorn/future.commynity.com/sockets/universe.sock"
  pid         "#{proj_root_dir}/sample_app/tmp/pids/unicorn.pid"
  stderr_path "#{proj_root_dir}/sample_app/log/unicorn.log"
  stdout_path "#{proj_root_dir}/sample_app/log/unicorn.log"
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