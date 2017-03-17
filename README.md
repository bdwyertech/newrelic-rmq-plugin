# newrelic-rmq-plugin
* NewRelic RabbitMQ Plugin Agent
* Polls RabbitMQ for Metrics & Ships to NewRelic
* Monitors for Cluster Partitions & Stopped Nodes

## Background
This is based primarily off of the [RedBubble NewRelic RabbitMQ Agent](https://github.com/redbubble/newrelic-rabbitmq-agent)
The idea was to package this is a gem for simplified deployment, and add/adjust some functionality.

## Running as a Service
You'll likely want to run this as a service, `SystemD` or `Upstart` will likely be your friend in this regard.

#### Upstart Example
```bash
description 'NewRelic RabbitMQ Agent'
start on started network-interface INTERFACE!=lo
stop on runlevel [!2345]

setuid nobody
setgid nogroup

respawn
respawn limit 5 2

script
  exec newrelic-rmq-plugin --nr-cfg-file /etc/newrelic/rabbitmq.yml
end script
```


## Security
You should lock down permissions on all configuration files in this project to only the user which this runs as...

To run this project securely, **DON'T** run it as the RabbitMQ or root user.

For Global Metrics, the RabbitMQ user should have the `monitoring` tag.  For Per-Queue Metrics, the RabbitMQ user should exist on the vHost.  It does not need read/write/config.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'newrelic-rmq-plugin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install newrelic-rmq-plugin

## Usage

    $ newrelic-rmq-plugin --nr-cfg-file /etc/newrelic/rabbitmq.yml

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bdwyertech/newrelic-rmq-plugin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
