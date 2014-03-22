#> デプロイ先のサーバーのディレクトリ
set :deploy_to, '/var/www/capistrano.test'
set :rails_env, 'development'
set :migration_role, 'db'
set :bundle_without, 'production'

server 'aws.future.commynity.com', user: 'ec2-user', roles: %w{web app db}, ssh_options: {
  keys: [File.expand_path('~/.ssh/koganezawaPersonalKey.pem')],
  forward_agent: true,
  auth_methods: %w(publickey)
}