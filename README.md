Setup development env

1. git clone <https://github.com/XpaH/Svadba.org.git>

2. cd directory

3. bundle install(resolving problems)

4. copy config.yml.example and database.yml.example to config.yml and database.yml

5. change adapter in database.yml to <postgresql>

6. rake db:create db:migrate


#Testing

We are using rspec as test lib. For better testing you can use 2 gems
[spin](https://github.com/jstorimer/spin)
[kicker](https://github.com/alloy/kicker)

If you don't want use this libs, run your tests as usual

```ruby
  rspec
```

## Prepare your test env

1. ```ruby gem install spin ```

2. ```ruby gem install kicker -s http://gemcutter.org ```

3. ```ruby spin serve ```

4. cd project derectory and run ```ruby kicker -r rails -b 'spin push'
```

See test's results in console window, where you run spin serve. If you
use mac os x as a develop platform, notifications will be performed in
top right corner of screen.
