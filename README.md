# Rails Template API
Rails 6 API template with token auth, swagger, rspec tests, postman and a sample
resource. 

## Version
* Ruby 2.7.1
* Rails 6.0.2.2

## Usage

### Postman
A postman collection and environment are located in the Postman folder

## Development

### Using the template
* Find and replace rails_template with <Project Name>
* Close rubyMine and delete the .ideafile in the template project
* Open the project and bundle install
* Change any models or migrations (db has not been migrated)
* Setup the DB using the steps below

### Installing Rails
* Install the proper ruby version (2.7.1): rbenv install 2.7.1  
* Switch to the proper ruby version: rbenv global 2.7.1
* Install the proper rails version (6.0.2.2): gem install rails -v 6.0.2.2
* Any issue follow this guide: https://gorails.com/setup/osx/10.15-catalina

### DB Setup
* Install Postgres.app
* Install pg gem: gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/latest/bin/pg_config
* Add development table: CREATE DATABASE rails_template_development;
* Add test table: CREATE DATABASE rails_template_test;
* migrate data: rails db:migrate

### Testing
* rspec based testing

#### Swagger
* Generate new swagger docs: rake rswag:specs:swaggerize 

### Authentication
* This application uses devise and devise-token-auth documentation can be found here: https://devise-token-auth.gitbook.io/devise-token-auth/