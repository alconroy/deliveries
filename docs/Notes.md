# Rails & Heroku Notes

## Local Setup
- The development environment tries to mirror the Heroku setup.
- Using PostgreSQL as the development database
- It is also setup to use `foreman` from Heroku's development tools, in order to run the app with **Unicorn** Heroku's recommended server.
- Should work just as well with the default `sqlite` and `webrick` for development.

### Postgres Setup
- If necessary change db names in *config/database.yml*
- Run `rake db:create` and `rake db:migrate` and `rake db:seed` (for some default data), to setup DB
- To reset the database on Heroku use `heroku pg:reset <DATABASE>`, get the database name from `heroku pg:info`
	- then recreate database with `heroku run db:migrate` and seed with data `heroku run db:seed`

### Server Setup
- Unicorn uses the `Procfile` to configure the server.
- Use foreman `.env` file to set some variables for the server.
```
echo "RACK_ENV=development" >> .env
echo "PORT=3000" >> .env
```
- Post deploy can set `RACK_ENV` to *production* to ensure working correctly.
- Run with `foreman start`

## Devise
Setup required on install:
1. Ensure you have defined default url options in your environments files. Here is an example of default_url_options appropriate for a development environment in *config/environments/development.rb*:
```
config.action_mailer.default_url_options = { host: 'localhost:3000' }
```
In production, :host should be set to the actual host of your application.
2. Ensure you have defined root_url to **something** in your *config/routes.rb* like `root to: "home#index"`
3. Ensure you have flash messages in *app/views/layouts/application.html.erb*.
```
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```
4. If you are deploying on Heroku with Rails 3.2 only, you may want to set:
```
config.assets.initialize_on_precompile = false
```
On config/application.rb forcing your application to not access the DB or load models when precompiling your assets.
5. You can copy Devise views (for customization) to your app by running:
```
rails g devise:views
```

- helper methods:
```
before_action :authenticate_user!
user_signed_in?
current_user
user_session
```

## Rails Console
- `rails c`
- add user
```
u = User.new(:email => "user@name.com",
		:password => 'password',
		:password_confirmation => 'password',
		:admin => false)
u.save
```

## RSpec/Testing
- run `rake db:migrate` and `rake db:test:prepare` (deprecated now)
- may also need to run `rake db:create:all`
- `rake spec` to run all specs, use `rake -T` to see all tasks, also `bundle exec rspec`
- FactoryGirl `create()` saves to db, availabe to all other examples in context (also whole run?)
- `before :all` blocks do not rollback after testing
- FactoryGirl and Faker creating same content every call, use brakcets
`email { Faker::Internet.email }` [source](http://objectliteral.blogspot.ie/2009/07/make-faker-work-with-factory-girl.html)

## Capybara
**Options Hash**
- text (String, Regexp) — Only find elements which contain this text or match this regexp
- visible (Boolean) — Only find elements that are visible on the page. Setting this to false finds invisible and visible elements.
- count (Integer) — Exact number of matches that are expected to be found
- maximum (Integer) — Maximum number of matches that are expected to be found
- minimum (Integer) — Minimum number of matches that are expected to be found
- between (Range) — Number of matches found must be within the given range
- exact (Boolean) — Control whether `is` expressions in the given XPath match exactly or partially


## Rails General
- run method before selected controller actions
```
before_action :set_user, only: [:edit, :update, :destroy]
```
- to clean database
```
rake db:reset
rake db:migrate
```
- or
```
rake db:drop
rake db:create
rake db:migrate
# equal to
rake db:drop db:create db:migrate
```
- seed database `rake db:seed`
- after clean need `rake db:test:prepare`
- in rails console `reload!` to reload env

### Asset Pipeline
- for icon fonts e.g. foundation-icons
- rename to `foundation-icons.scss` (SASS)
- and change `url(...)` to `font-url(...)`

## XPath
- dealing with sub nodes and text elements
```
//div[div[text()
	[normalize-space() = 'quick@test.com']]]
	/div/a[@data-method='delete']
```

## Bing Javascript API
- the script will make another script call (veapicore.js)
	- default is to use no ssl (http), use `&s=1` param for ssl
	`https://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=7.0&s=1`
