[![Build Status](https://travis-ci.org/existsec/ucsimc.svg?branch=master)](https://travis-ci.org/existsec/ucsimc)
# Ucsimc
Ucsimc implements the Cisco XML API for Cisco UCS Central in Ruby. It wraps the Cisco XML
API methods into easy to use ruby methods with the necessary parameters to handle
low level queries against UCS Central. IMC implements additional logic on top of
the API methods allowing the extension of the base API methods into more useful
tools.

Notes: This is a really early build. Basic querying of the api functionality
is implemented. Further validation and error handling need to be done still.
You'll need to know the dn or class you're wanting to query. Configuration support
is implemented. Again you'll need to know the dn and class and provide a hash for configuration.
Will work well with yaml file configuration as a source (not implemented).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ucsimc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ucsimc

## Usage


### Pry instructions for now
These can be run without building if you have the nokogiri gem installed already. 
Change the @LOAD_Path value replacing <your path here> if you want to clone and test
without building.

#### Resolve children of parent object
```
$LOAD_PATH.unshift("<your path here>/git/ucsimc/lib")

require 'ucsimc'
ucs = Ucsimc::IMC.connect({:user => "user", :pass => "pass", :host => "ipaddress", :verify_ssl => '"false"' })
ucs.in_dn = "domaingroup-root/fabric/lan"
ucs.in_class = "fabricVlan"
ucs.resolve_children
ucs.out_dn
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ucsimc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
