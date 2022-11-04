# Dragonfly::Cache::Plugin

A simple local file cache plugin for the dragonfly image processing gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dragonfly-cache-plugin'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dragonfly-cache-plugin

## Usage

Require the gem somewhere in your code, for rails a good choice is `config/initializers/dragonfly.rb`

    require 'dragonfly/plugin/cache'

And then add the plugin to your dragonfly config

    Dragonfly.app.configure do
      url_format "/media/:sha/:name"
      plugin :dragonfly_cache public_path: Rails.root.join('public')
      ...
    end

By default the UrlFormat adapter is used. It stores the generated files to the `app.server.url_format` config. You should configure your reverse proxy (NGINX, Apache etc) to try for the file first and then pass to the dragonfly server. Simple sample NGINX config:

    location ~* ^/media/.*\.(png|jpe?g|webp) {
      root /var/www/app/public;
      expires 1y;
      add_header Cache-Control public;
      try_files $uri @backend; 
    }
    
    location @backend {
      include /etc/nginx/snippets/proxy_headers.conf;
      proxy_redirect off;
      proxy_pass http://app;
    }

CAUTION: make sure to define the url_format before you register the plugin if you use the adapter url_format

You should also consider not using the plugin in test and development by e.g.

    if Rails.application.config.action_controller.perform_caching
      plugin :dragonfly_cache, public_path: Rails.root.join('public')
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Promptus/dragonfly-cache-plugin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Promptus/dragonfly-cache-plugin/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dragonfly::Cache::Plugin project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Promptus/dragonfly-cache-plugin/blob/main/CODE_OF_CONDUCT.md).
