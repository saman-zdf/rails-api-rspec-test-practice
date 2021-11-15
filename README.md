# Day-1: up to 23:47 been watched:

Added some gems in the test env in Gemfile:
gem "rspec-rails"
gem "factory_bot_rails"
gem "database_cleaner"
gem "rails-controller-testing"

---

configured rails_helper in the spec dir:
line 23:
should be un-commented
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

line 40:
it is originally is true, it has to be false
config.use_transactional_fixtures = false

---

need a support dir for configuration in spec directory for database_cleaner.rb and factory_bot.rb.

the database_cleaner.rb needs the below configs:
RSpec.configure do |config|

# it will tell the database cleaner how to clean beofre suite

config.before(:suite) do
DatabaseCleaner.clean_with(:truncation)
end

# it will tell the database cleaner of what strategy to use, which in this case is going to be transaction

config.before(:each) do
DatabaseCleaner.strategy = :transaction
end

# start after each test

config.before(:each) do
DatabaseCleaner.start
end

# clean after each test

config.after(:each) do
DatabaseCleaner.clean
end

# same spiel for all the data in database

config.before(:all) do
DatabaseCleaner.start
end

config.after(:all) do
DatabaseCleaner.clean  
 end
end

the factory_bot.rb needs the below configs:
RSpec.configure do |config|
config.include FactoryBot::Syntax::Methods
end

---
