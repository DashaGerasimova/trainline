# ComTheTrainline

## Installation

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Usage
To request the list of journeys, call:
```
ComThetrainline.find(from: "Lisbon", to: "Porto", departure_at: DateTime.current)
```
Or, to get the closest tickets: 
```
ComThetrainline.find(from: "Lisbon", to: "Porto")
```

Here's the sample of data that it will return: 
```ruby
{
  :departure_station=>"Berlin Hbf (tief)",
  :departure_at=>2024-05-06 07:54:00 +0200,
  :arrival_station=>"München Marienplatz",
  :arrival_at=>2024-05-06 13:16:00 +0200,
  :duration_in_minutes=>322,
  :changeovers=>1,
  :service_agencies=>["trainline"],
  :products=>["db_pst"],
  :fares=>
   [{:name=>"Super Sparpreis", :price_in_cents=>41.8, :currency=>"EUR", :comfort_class=>"Standard"},
    {:name=>"Sparpreis", :price_in_cents=>48.8, :currency=>"EUR", :comfort_class=>"Standard"},
    {:name=>"Flexpreis", :price_in_cents=>148.5, :currency=>"EUR", :comfort_class=>"Standard"},
    {:name=>"Super Sparpreis", :price_in_cents=>53.8, :currency=>"EUR", :comfort_class=>"First"},
    {:name=>"Sparpreis", :price_in_cents=>62.8, :currency=>"EUR", :comfort_class=>"First"},
    {:name=>"Flexpreis", :price_in_cents=>267.3, :currency=>"EUR", :comfort_class=>"First"}]
}
```