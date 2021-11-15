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