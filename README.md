# Jackhammer

Jackhammer is an opinionated, configurable facade over the RabbitMQ Bunny
module.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jackhammer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jackhammer

## Usage

Create a YAML file to configure topics and queues your Jackhammer::Server instance
will subscribe to when using the executable.

```YAML
# config/jackhammer.yml
---
default: &default
  weather:
    auto_delete: false
    durable: true
    queues:
      americas.south:
        auto_delete: true
        durable: false
        exclusive: false
        handler: "MyApp::SouthAmericaHandler"
        routing_key: "americas.south.#"

development:
  <<: *default

development:
  <<: *default

production:
  <<: *default
```

Configure your subscription server by sublcassing `Jackhammer::Server`.

```Ruby
# config/application.rb
require 'jackhammer'

module MyApp
  class Server < Jackhammer::Server
    Jackhammer.configure do |jack|
      jack.connection_options = {}
      jack.connection_url =     nil
      jack.environment =        ENV['RACK_ENV'] || :development
      jack.exception_adapter =  NullExceptionAdapter.new
      jack.logger =             Logger.new(IO::NULL)
      jack.publish_options =    { mandatory: true, persistent: true }
      jack.yaml_config =        "config/jackhammer.yml"
    end
  end
end
```

Start the subscription server to read the YAML and subscribe to topic queues.

```
$ bundle exec jackhammer -r config/application.rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jackhammer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jackhammer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/renofi/jackhammer/blob/master/CODE_OF_CONDUCT.md).
