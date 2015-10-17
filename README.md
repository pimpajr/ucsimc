[![Build Status](https://travis-ci.org/existsec/ucsimc.svg?branch=master)](https://travis-ci.org/existsec/ucsimc)
# Ucsimc
Ucsimc implements the Cisco XML API for Cisco UCS Central in Ruby. It wraps the Cisco XML
API methods into easy to use ruby methods with the necessary parameters to handle
low level queries against UCS Central. IMC implements additional logic on top of
the API methods allowing the extension of the base API methods into more useful
tools.

After establishing a valid connection Ucsimc will allow the following methods:
 - resolve_class
 - resolve_children
 - resolve_dn
 - config_mo

## resolve_class
Takes @in_class as a string.
Outputs to @out_dn

## resolve_children
Takes @in_class and @in_dn. Resolves the @in_class children of @in_dn.
Outputs to @out_dn

## resolve_dn
Takes @in_dn and outputs @out_dn

## config_mo
Currently doesn't do_post, just builds the xml and outputs it.
Still in testing with this. xml output is correct still need to test
how UCS central handles it. Right now it's parsing @fabricVlans which
would be a hash of dn => {values}. The dn gets set as the dn in the top
level of the xml sent to the api while {value} gets passed to the inner 
part of the xml doc that sets the options. The class to configure specification
is still set statically and needs to be moved to allow it to be set externally.

Example output:
```
<configConfMo
    dn=""  
    cookie="<real_cookie>" 
    inHierarchical="false">
    <inConfig>
       <aaaLdapEp
          attribute="CiscoAvPair"
          basedn="dc=pasadena,dc=cisco,dc=com"   
          descr=""
          dn="sys/ldap-ext"
          filter="sAMAccountName=$userid"
          retries="1"   
          status="modified"
          timeout="30"/>
    </inConfig>
</configConfMo>
```

Notes: This is a really early build. Basic querying of the api functionality
is implemented. Further validation and error handling need to be done still.
You'll need to know the dn or class you're wanting to query. Configuration support
is in the works. Again you'll need to know the dn and class and provide a hash for configuration.
Will work well with yaml file configuration as a source (not implemented). 

Verify_ssl is currently broken, it doesn't verify right now. 

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
These can be run without building if you have the nokogiri and rest-client gems installed already. 
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
