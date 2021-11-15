# Day-1: up to 23:47 been watched:

Added some gems in the test env in Gemfile:

```Ruby
gem "rspec-rails"
gem "factory_bot_rails"
gem "database_cleaner"
gem "rails-controller-testing"
```

---

configured rails_helper in the spec dir:
line 23:
should be un-commented

```Ruby
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
```

line 40:
this line is originally true, it has to be false

```Ruby
config.use_transactional_fixtures = false
```

---

need a support dir for configuration in spec directory for database_cleaner.rb and factory_bot.rb.

the database_cleaner.rb needs the below configs:
RSpec.configure do |config|

- it will tell the database cleaner how to clean beofre suite

```Ruby
config.before(:suite) do
DatabaseCleaner.clean_with(:truncation)
end

- it will tell the database cleaner of what strategy to use, which in this case is going to be transaction

config.before(:each) do
DatabaseCleaner.strategy = :transaction
end

- start after each test

config.before(:each) do
DatabaseCleaner.start
end

- clean after each test

config.after(:each) do
DatabaseCleaner.clean
end

- same precedure for all the data in test database

config.before(:all) do
DatabaseCleaner.start
end

config.after(:all) do
DatabaseCleaner.clean
 end
end

- the factory_bot.rb needs the below configs:
  RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  end
```

---

- Day-2: minutes 40:00,
  the first model should be created, when we generate the model we also get two different dirs with files in out spec dir, 1. factory/categories.rb: in this file we can pass some dummy data for some basic test. 2. model/ctegory_spec.rb, in this file you can write all your test for your category model.

1. categories.rb can contain the below code(just for reminder):

```Ruby
require 'rails_helper'

RSpec.describe Category, type: :model do

  context 'factory' do
    before(:all) do
      # diff between create and build is create will save the data in database but build does not save the data
      @category = build(:category)
    end

    it "has a valid factory" do
      expect(@category).to be_valid
    end

    it "has the right name" do
      expect(@category.name).to eq("Awesome Category")
    end
  end
end

```

2. factory/categories.rb can have the below codes:

```Ruby
FactoryBot.define do
  factory :category do
    # this is a fake data for category
    name { "Awesome Category" }
  end
end
```

---
