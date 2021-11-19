[![Gem Version](https://badge.fury.io/rb/jackhammer.svg)](https://rubygems.org/gems/jackhammer)
[![Build Status](https://github.com/RenoFi/jackhammer/actions/workflows/ci.yml/badge.svg)](https://github.com/RenoFi/jackhammer/actions/workflows/ci.yml?query=branch%3Amain)

## !!! NO LONGER MAINTANED !!!

RenoFi moved to Google Pub/Sub and doesn't use rabbitmmq/jackhammer anymore.


# jackhammer

`jackhammer` is an opinionated, configurable facade over the RabbitMQ Bunny
module.

## Installation

Add this line to your application's Gemfile:

    gem 'jackhammer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jackhammer

## Usage

### Quick Start

Create a YAML file to configure topics and queues your Jackhammer::Server instance
will subscribe to when using the executable.

```yaml
# config/jackhammer.yml
---
default: &default
  weather:
    auto_delete: false
    durable: true
    queues:
      # queue_name => options pairs
      americas.south:
        auto_delete: true
        durable: false
        exclusive: false
        handler: "MyApp::SouthAmericaHandler"
        routing_key: "americas.south.#"
      americas.north:
        auto_delete: true
        durable: false
        exclusive: false
        handler: "MyApp::NorthAmericaHandler"
        routing_key: "americas.north.#"
      # or an array
      - queue_name: americas.south
        auto_delete: true
        durable: false
        exclusive: false
        handler: "MyApp::SouthAmericaHandler"
        routing_key: "americas.south.#"
      # queue_name can be skipped and auto generated from routing key
      - auto_delete: true
        durable: false
        exclusive: false
        handler: "MyApp::SouthAmericaHandler"
        routing_key: "americas.south.#"

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
```

Configure your subscription server by sublcassing `Jackhammer::Server`.

```ruby
# config/environment.rb
require 'jackhammer'

module MyApp
  class Server < Jackhammer::Server
    configure do |config|
      # these are the default options
      config.connection_options = {}
      config.connection_url     = nil
      config.environment        = ENV['RACK_ENV'] || :development
      config.exception_adapter  = proc { |e| raise e }
      config.logger             = Logger.new(IO::NULL)
      config.publish_options    = { mandatory: true, persistent: true }
      config.yaml_config        = "config/jackhammer.yml"
      config.app_name           = "my_app"
      config.client_middleware.use MyClientMiddleware, some_arg: 1, other_arg: 2
      config.server_middleware.use MyServerMiddleware
    end
  end
end
```

Start the subscription server to read the YAML and subscribe to topic queues.

    $ bundle exec jackhammer

### Topic Exchange Configuration

The YAML file configures [RabbitMQ Topic Exchanges](https://www.rabbitmq.com/tutorials/amqp-concepts.html#exchange-topic).

At the root are environment names used to load environment specific
configuration. Below that are the names of topic exchanges.  Each topic exchange
can define `durable` and `auto_delete` options used when creating the exchange.
Additionally, each topic exchange defines a `queues` mapping.  Each mapping
nested under the `queues` key represents options used by either Jackhammer or
Bunny.

Exchange topic queue options passed to Bunny during [queue initialization](http://reference.rubybunny.info/Bunny/Queue.html#initialize-instance_method):

- **durable** default: false — Should this queue be durable?
- **auto_delete** default: false — Should this queue be automatically deleted when the last consumer disconnects?
- **exclusive** default: false — Should this queue be exclusive (only can be used by this connection, removed when the connection is closed)?

The **routing_key** is used as an option when binding the Bunny::Queue and
Bunny::Exchange.

Exchange topic queue options used by Jackhammer:

- **handler** A string representing the name of a class that is intended to
  receive messages delivered to the queue subscriber.

The handler class must implement at least a `.call` method. If the class
responds to `.perform_async` then that will be called instead of `.call`.

```ruby
module MyApp
  class SouthAmericaHandler
    def self.call(message)
      puts message
    end
  end
end
```

### Executable

By default the executable will load `config/environment.rb`. If you define
and configure your Jackhammer server somewhere else, use the `-r path/file.rb`
option on the command line.

    $ bundle exec jackhammer -r config/rabbitmq_application.rb

### Server  Configuration

The `configure` block must be placed inside of your application class even if
you choose not to change any default configuration.

The intent of the options might not be obvious by looking at the name.
- **connection_options** passed into `Bunny.new`.
- **connection_url** passed into `Bunny.new`.
- **environment** specifies the section of YAML config to load.
- **exception_adapter** exceptions caught when handling received messages are
  forwarded to the adapter object. The adapter must implement
  `.call(exception)`.
- **logger** defines a logger the Jackhammer module should use.
- **publish_options** defines options passed to all messages published (can be
  overridden by passing the same options as arguments in your code).
- **yaml_config** defines the file location of the Topic Exchange YAML
  configuration file.
- **client_middleware** defines hooks that will be executed prior to publishing a message to a topic
- **server_middleware** defines hooks that will be executed prior to running the message handler

You can find defaults specified in the Jackhammer::Configuration class
constructor.

### Middleware

Middleware allows you to hook into message publishing (client) and handling (server).

It can be used to transform the passed in arguments before passing them along or to halt the execution completely.
The execution will be halted if the middleware instance does not yield.

#### Example client middleware

```ruby
class MyClientMiddleware
  def initialize(name)
    @name = name
  end
  
  def call(message, options)
    options[:headers][:hello] = @name

    yield message, options
  end
end
```

#### Example server middleware

```ruby
class MyServerMiddleware
  def call(handler:, delivery_info:, properties:, content:)
    puts "Hello, #{properties[:headers]['name']}!"

    yield handler: handler, delivery_info: delivery_info, properties: properties, content: content
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renofi/jackhammer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
