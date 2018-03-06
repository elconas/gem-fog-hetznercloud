
# Rubygem fog-hetznercloud

Fog provider gem to support [Hetzner Cloud](https://cloud.hetzner.com/).

## Features and development

This gem is currently a MVP prototype that is missing some features:

API:
* [Pagination Support](https://docs.hetzner.cloud/#header-pagination-1)
* [Rate Limiting Support](https://docs.hetzner.cloud/#header-rate-limiting-1)
* [Support for ISO's](https://docs.hetzner.cloud/#resources-isos)
* [Support for Prices](https://docs.hetzner.cloud/#resources-pricing-get)
* [Metrics Support](https://docs.hetzner.cloud/#resources-servers-get-2)

GEM:
* Tests
* Travis CI Support
* Support for reating token from hcloud config files (.config/hcloud/cli.toml)

The development is tracked on this [trello card](https://trello.com/b/MXesMrnL/fog-hetznercloud).

If you would like to help, please make pull requests on [github](https://github.com/elconas/gem-fog-hetznercloud).

## Installation

**NOTE: Ruby 2.0 or later is required. You can use [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/) to make this gem work with Ruby 1.9.**

Add this line to your application's Gemfile:

```ruby
source "https://rubygems.org"
gem 'fog-hetznercloud'
```

And then execute to install requirements

    $ bundle

Run scripts with:

    $ bundle exec ruby script.rb

## Configuration

Put your credentials to the fog configuration file:

```yaml
default:
  hetznercloud_token: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # Your API token
```

## Example

### Gemfile

```ruby
source "https://rubygems.org"
gem 'fog-hetznercloud'
```

### Prepare

```shell
shell$ bundle
```

### Create, execute and Destroy Server

```ruby
#!/usr/bin/env ruby2.0
require 'fog/hetznercloud'
require 'pp'

# Connecto to Hetznercloud
connection = Fog::Compute[:hetznercloud]

# Some variables
ssh_keyfile = "./testkey.pub"	# needs to be generated first with 'ssh-keygen -t rsa testkey'
servername = "test1"            # Name of the server
ssh_keyname = "test"            # Name of the ssh key

## create or select ssh key ...
ssh_key = connection.ssh_keys.all(:name => ssh_keyname).first
if !ssh_key
  puts "Creating SSH Key ..."
  ssh_key = connection.ssh_keys.create(:name => ssh_keyname, :public_key => ssh_keyfile)
else
  puts "Using existing SSH Key ..."
end

# lookup existing server by name or create new server, works with most resources
server = connection.servers.all(:name => servername).first
if !server
  puts "Creating Server ..."
  server = connection.servers.create(:name => servername, :image => 'centos-7', :server_type => 'cx11', :ssh_keys => [ ssh_key.identity ])
else
  puts "Using existing Server ... "
end

# now wait for the server to boot
puts "Waiting for Server SSH ..."
server.wait_for {  server.sshable? }

puts "SSH in server ..."
puts server.ssh('uname').first.stdout # => "Linux\r\n"

puts "Destroy Server ..."
server.destroy
```

Execute:

```
bundle exec ruby script.rb
```

## Reference

See https://docs.hetzner.cloud/ for API reference.

FIXME: To be documented

## Development

**Note: MOCK is currently not implemented, feel free to provide pull requests**

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test FOG_MOCK=true` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elconas/gem-fog-hetznercloud.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/apache-2.0).
