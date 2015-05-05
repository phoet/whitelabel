# Whitelabel

This gem helps you providing whitelabel functionality in your application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whitelabel'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install whitelabel
```

## Usage

You can start with a pretty simple, file driven whitelabel configuration.

All you need is a config file:

```yaml
# config/whitelabel.yaml
---
- !ruby/struct:YourLabelClass
  label_id: "white"
  some_config: "for your application"
```

and an initializer:

```ruby
# config/initializers/whitelabel.rb
YourLabelClass = Struct.new :label_id, :some_config
Whitelabel.from_file Rails.root.join("config/whitelabel.yml")
```

Whitelabel works the same way I18n does, just set it up in your ApplicationController:

```ruby
    # app/controllers/application_controller.rb
    before_filter :switch_label
    
    def switch_label
      unless Whitelabel.label_for(request.subdomains.first)
        redirect_to(labels_url(subdomain: false), alert: "Please select a Label!")
      end
    end
```

This example uses the subdomain to determine which label should be active, but you can implement whatever you like here.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
