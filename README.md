# Contour

[![Build Status](https://travis-ci.org/remomueller/contour.svg?branch=master)](https://travis-ci.org/remomueller/contour)
[![Dependency Status](https://gemnasium.com/remomueller/contour.svg)](https://gemnasium.com/remomueller/contour)
[![Code Climate](https://codeclimate.com/github/remomueller/contour/badges/gpa.svg)](https://codeclimate.com/github/remomueller/contour)

Basic Rails framework files and assets for layout and authentication

## Installation

Contour can be installed from rubygems.org using

```
gem install contour
```

Or update your `Gemfile` to include

```ruby
gem 'contour'
```

## Getting started

Make sure you have Rails 4.2.0

```
rails -v

rails new blank_rails_project

cd blank_rails_project
```

Modify `Gemfile` and add

```ruby
gem 'contour', '~> 3.0.0'
```

Run Bundle install

```
bundle install
```

Install contour files

```
rails generate contour:install
```

Create a sample controller

```
rails generate controller welcome index --skip-stylesheets
```

Add the following line to your `app/controllers/application_controller.rb`

```ruby
layout "contour/layouts/application"
```

Edit your `app/assets/javascripts/application.js` manifest to use Contour JavaScript (Replace `jquery` and `jquery_ujs`)

```
//= require contour
```

Add contour javascript if desired to the `$(document).ready()` function: `app/controllers/my_app.js.coffee`

```coffee
@ready -> ()
  contourReady()
  ... # Your page-ready code

$(document).ready(ready)
$(document).on('page:load', ready) # For turbolinks
```

Edit your `app/assets/stylesheets/application.css` manifest to use Contour CSS (after `self`, before `tree`)

```
*= require contour
```

Make sure the devise line in `config/routes.rb` looks as follows

```ruby
devise_for :users, controllers: { registrations: 'contour/registrations', sessions: 'contour/sessions', passwords: 'contour/passwords', confirmations: 'contour/confirmations', unlocks: 'contour/unlocks' }, path_names: { sign_up: 'register', sign_in: 'login' }
```

**If there is a line that just says `devise_for :users` or a duplicate, REMOVE IT!**

Create a root in your `config/routes.rb`

```ruby
root to: 'welcome#index'
```

Add the following to the top of your `app/controllers/welcome_controller.rb`

```ruby
before_action :authenticate_user!
```

Edit `config/initializers/devise.rb` to use `:get` for devise `sign_out_via`

```ruby
# The default HTTP method used to sign out a resource. Default is :delete.
config.sign_out_via = :get
```

Start your server and navigate to [http://localhost:3000/users/login](http://localhost:3000/users/login)

```
rails s
```

You can then sign in using your [Google Account](http://localhost:3000/auth/google_apps?domain=gmail.com) or by registering for an account at [http://localhost:3000/users/register](http://localhost:3000/users/register)

## Overwrite Default Rails Scaffolding (optional)

Add [Kaminari](https://github.com/amatsuda/kaminari) gem to your `Gemfile`

```ruby
gem 'kaminari', '~> 0.16.3'
```

Update your gems

```
bundle update
```

Create a new model using the Rails scaffold

```
rails g scaffold Item name:string description:text user_id:integer bought_date:date --no-stylesheets
```

Add a current `scope` and `belongs_to` relationship to `app/models/item.rb`

```ruby
scope :current, -> { all }

belongs_to :user
```

Add a current `scope` and `has_many` relationship to `app/models/user.rb` along with name placeholder

```ruby
scope :current, -> { all }

has_many :items

def name
  "User ##{self.id}"
end
```

Add a user resource to your `config/routes.rb` file

```ruby
resources :users
```

NOTE: Adding the User controller is not shown, but could be created using `rails g controller Users index show edit update destroy --no-stylesheets`. Remember that the `new` and `create` actions are already defined and should be left commented out.

Migrate your database

```
bundle exec rake db:migrate
```

Update with the Contour scaffold

```
rails g contour:scaffold Item
```

When prompted to overwrite the existing files, type `a` for ALL.

NOTE: This will overwrite all the files generated by the rails scaffold command!

Go to [http://localhost:3000/items](http://localhost:3000/items) to see the changes! Note, that the `user_id` selection now defaults to a drop down box!

## Inspiration and Attribution

Contour is designed to rapidly prototype Rails applications with nice default styling and a solid authentication system. The Contour code base has been influenced by existing Rails Engines architectures that are listed below. Please check them out if you are interested in seeing how Contour is put together!

### Devise

[Devise](https://github.com/plataformatec/devise) is the highly configurable authentication gem that Contour utilizes.

Contour has adopted Devise's installation and configuration approach `rails generate devise:install` and `config/intializers/devise.rb`.

### Twitter Bootstrap Rails

While Contour doesn't have an external dependency on the [Twitter Bootstrap Rails](https://github.com/seyhunak/twitter-bootstrap-rails) gem, Contour does adopt the templating approach, `rails generate contour:scaffold ModelName`, used to overwrite the default scaffolding provided by Rails.

For those interested in having better control on modifying the Twitter Bootstrap Less file and CSS, I highly recommend taking a look at Twitter Bootstrap Rails!

## Contributing to Contour

- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright [![Creative Commons 3.0](http://i.creativecommons.org/l/by-nc-sa/3.0/80x15.png)](http://creativecommons.org/licenses/by-nc-sa/3.0)

Copyright (c) 2015 Remo Mueller. See [LICENSE](https://github.com/remomueller/contour/blob/master/LICENSE) for further details.
