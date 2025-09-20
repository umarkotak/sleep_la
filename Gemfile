source "https://rubygems.org"

gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "pg"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "dotenv"
gem "jwt"
gem "sorbet", group: :development
gem "sorbet-runtime"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails"
  gem "pry"
  gem "tapioca", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "ruby-lsp"
  gem "ruby-lsp-rspec"
end
