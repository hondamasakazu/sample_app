source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'
gem 'bootstrap-sass', '2.3.2.0'
gem 'bcrypt-ruby', '~> 3.1.2'

# データ生成用
gem 'faker', '1.1.2'

# ページネーション
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.6'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.1.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.0.4'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '1.1.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '1.0.2'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
gem 'unicorn'

# プロセス起動
gem 'foreman'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Markdown
gem 'redcarpet'
gem 'coderay'

#content_type
gem 'mime-types'

#Aws
gem 'aws-s3'
gem 'aws-sdk'

gem 'newrelic_rpm'

group :test do

  # 振舞駆動テスティングフレームワーク
  gem 'rspec-rails', '2.13.1'

  # Rspec出力結果整形
  gem 'fuubar'

  # Guardによるテストの自動化
  gem 'guard-rspec', '2.5.0'

  # Spork を使ったテストの高速化
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.9'

  gem 'selenium-webdriver', '2.35.1'

  # Webのアクセスをシミュレートするヘルパー
  gem 'capybara', '2.1.0'
  # Uncomment this line on OS X.
  gem 'growl', '1.0.3'

  # スタブ生成ライブラリー
  gem 'factory_girl_rails', '4.2.1'

  # 受け入れテストのためのテスティングフレームワーク
  gem 'cucumber-rails', '1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

  # Uncomment these lines on Linux.
  # gem 'libnotify', '0.8.0'

  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.2'
end

# Use debugger
# gem 'debugger', group: [:development, :test]
# Debugger
group :test, :development do
  # Pry本体
  gem 'pry'
  # デバッカー
  gem 'pry-remote'
  gem 'pry-debugger'
  # show-stackコマンド,framコマンド
  gem 'pry-stack_explorer'
  # Railsコンソールの多機能版
  gem 'pry-rails'
  # PryでのSQLの結果を綺麗に表示
  gem 'hirb'
  gem 'hirb-unicode'
  # pry画面でのドキュメント/ソース表示
  gem "pry-doc"
  # pryの色付けをしてくれる
  gem 'awesome_print'
  # pryの入力に色付け
  gem 'pry-coolline'

  # Railsエラー画面を奇麗にしてくれる
  gem 'better_errors'
  gem 'binding_of_caller' # エラー発生時その場でデバッグするのに必要なGem

  # 不要なログを出力させない（静的コンテンツへのGetリクエスト等）
  gem 'quiet_assets'
  # 開発用DB
  gem 'mysql2'

end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '0.3.20', require: false
end

# from heroku
group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end
