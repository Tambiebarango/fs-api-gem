# Fullscriptapi

Are you building to Fuelscropt's API and is your stack in `ruby`? If so, here's a gem for you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fullscriptapi'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fullscriptapi

## Usage

Initialize your client with

``` ruby
client = Fullscriptapi.config do |c|
  c.client_id = "your_client_id" # obtain it from the api dashboard
  c.secret = "your_client_secret" # obtain it from the api dashboard
  c.redirect_uri = "your_apps_redirect_uri" # obtain it from the api dashboard
  c.server = "dev" # choose one of us_prod, us_snd, ca_prod, ca_snd, dev
end
```

Next provide a token hash for your client like this

``` ruby
client.use_token(
  access_token: "access_token",
  refresh_token: "refresh_token",
  expires_in: 7200
)
```

Then you're ready to make api calls like this:

``` ruby
client.list_all_products
client.create_an_oauth_token(grant) #you'll need your auth grant for this
```

The method names on the `client` match the headings in the fuelscropt api documentation.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/fullscriptapi.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
