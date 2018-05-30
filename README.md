# Tracksale
Tracksale v2 API integration gem.

## Install

1. Add `gem 'tracksale'` into your Gemfile.
2. Run `bundle install`

## Configure

You must generate a Tracksale key on tracksale.co website and configure it on rails you can use an initializer.

config/initializers/tracksale.rb
```
Tracksale.configure do |config|
  config.key = 'YOUR_KEY_HERE'
end
```

Key generation instructions can be found on the official documentation at: https://api.tracksale.co/?lang=en#submenu1
## Using

After configuration you should be able to use it easily as in
```
Tracksale::Campaign.find_by_name('foobar') => #<Tracksale::Campaign:0x00559c458ec128
 @code=123,
 @name="foobar",
 @score={:detractors=>1, :passives=>2, :promoters=>3}>
```

## Debug

You can enable the HTTParty debug on the request by using the '-d' option on IRB or Ruby

## Limitations

This gem is on early stages of development and you will only be able to:

* Find campaigns by name ( `Tracksale::Campaign.find_by_name(name)` )
* List all campaigns ( `Tracksale::Campaign.all` )

Also you can only access 5 items from a campaign (name, code, detractors, passives and promoters).
