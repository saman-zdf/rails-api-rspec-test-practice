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

```Ruby
RSpec.configure do |config|
# - it will tell the database cleaner how to clean beofre suite

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

# - it will tell the database cleaner of what strategy to use, which in this case is going to be transaction

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

# - start after each test

  config.before(:each) do
    DatabaseCleaner.start
  end

# - clean after each test

  config.after(:each) do
    DatabaseCleaner.clean
  end

# - same precedure for all the data in test database

  config.before(:all) do
    DatabaseCleaner.start
  end

  config.after(:all) do
    DatabaseCleaner.clean
  end
end

```

In the factory_bot.rb we need the below configuration:

```Ruby
# the factory_bot.rb needs the below configs:
  RSpec.configure do |config|
    config.include FactoryBot::Syntax::Methods
  end
```

---

- Day-2: minutes 40:00,
  the first model should be created, when we generate the model we also get two different dirs with files in the spec dir, 1. factory/categories.rb: in this file we can pass some dummy data for some basic test. 2. model/ctegory_spec.rb, in this file you can write all your test for your category model.

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

### Adding User model

User model needs the:

```Ruby
has_secure_password
```

it also needs some validations in the user model:

```Ruby
validates :username, presence:true, uniqueness: true
validates :email, presence:true, uniqueness: true
validates :password, presence:true, confirmation: true
validates :password_confirmation, presence: true

```

In factory/users.rb you can put:

```Ruby
FactoryBot.define do
  factory :user do
    username { "Saman" }
    email { "sam@test.com" }
    password { "password1" }
  end
end
```

^^ just to test our user model.

next we need to write some test in our user_spec.rb, we can have as many tests as we want, but the basic would be enough for just to check if the user is valid or the username is equal to the one we testing

```Ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  # Factory context
  context "factory" do
    # before all the test we build the user instance for our test
    before(:all) do
      @user = build(:user)
    end
    # we can check to see if the @user is valid
    it "has a valid user" do
      expect(@user).to be_valid
    end
    # we can check to see if the @user or the user has the right username
    it "has the the correct username" do
      expect(@user.username).to eq ("Saman")
    end
    # we check to see if the user has the right password
    it "should has the right password" do
      expect(@user.password).to eq 'password1'
    end
  end
  # End of factory context

  # validation context
  context "validation" do
    before(:each) do
      @user = build(:user)
    end

    it "is invlaid without the username" do
      # here we change the existing username to nil to check the validation
      @user.username = nil
      expect(@user).to_not be_valid
    end

    it "is invalid without an email" do
      user = build(:user, {email: nil})
      expect(user).to_not be_valid
    end

    it "is invalid without password" do
      user = build(:user, {password: nil})
      expect(user).to_not be_valid
    end

    it "is invalid without password" do
      user = build(:user, {password_confirmation: nil})
      expect(user).to_not be_valid
    end

    it "is invalid when password and confirmation don't match" do
      user = build(:user, password_confirmation: "password2")
      expect(user).to_not be_valid
    end
  end
  # end of validation context
end

```

Time 1:02:13;

Creating a post model
when you created your post model, you have a ability of changing the user to author by using the below syntax in your post model belongs_to:

```Ruby
belongs_to :authour, class_name: "User", foreign_key: "user_id"
```

your user and category model need to have a:

```Ruby
# in your user model
has_may :posts
# in your category model
has_many :posts
```

In yor spec/post_spec.rb file you can test the association between your model by this long syntax, but there is gem call shoulda-matchers that can solve your problem in a very nicer way.

```Ruby
# The syntax is
it "shuold belong to the user" do
  t = Post.reflect_on_association(:author)
  expect(t.macro).to eq(:belongs_to)
end
```

The gem:

```Ruby
gem "shoulda-matchers"
```

once you install the gem with bundle install, you need create a file inside your spec/support dir and call it shoulda_matchers.rb and do some configuration for post model association test:

```Ruby
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

once the above config is done you can implement your association testing in you post_spec.rb:

```Ruby
  # this is a longer syntax to check the association between your model

  # it "should belong to a user" do
  #   t = Post.reflect_on_association(:author)
  #   expect(t.macro).to eq(:belongs_to)
  # end


  # this test is after we install the shoulda-matchers gem, it's shorter and a lot nicer syntax
  context "associations" do
    it {should belong_to(:author).class_name("User")}
    it {should belong_to(:category)}
  end


  # validation test
  context "validation" do
    it {should validate_presence_of(:title)}
    it {should validate_presence_of(:content)}
  end
```

### All the model has been added and been tested.

---

## controllers

First we can generate a category controller, when its generated we can implement some test in spec/request/categories_spec.rb. because we don't have any data in the category table we need to create category from our factory. the tests we need are:

```Ruby
 describe "GET /categories" do
    # because our database is empty we need to before all tests create(:category) to have data in our test database for the test
    before(:all) do
      create(:category)
    end

    before(:each) do
      get '/categories'
    end

    it "should respond with 200 ok" do
      expect(response).to have_http_status(200)
    end
    it "should respond with json" do
      expect(response.content_type).to eq("application/json; charset=utf-8")
    end
    it "should include" do
      expect(response.body).to include("Awesome Category")
    end

  end
```

once the test has been implemented we can run in terminal:

```
rspec
```

we should expect all the tests to fail, in this instance we have three test for our get request. next step is to create a index action in categories controller:

```Ruby
def index
  categories = Category.all
  render json: categories, status: 200
end
```

after we created a index action, we need to create categories route in route.rb:

```Ruby
get "/categories", to: "categories#index", as: "categories"
```

now if we run rspec, all the three test for get request will pass;
next step we need to add the faker gem to add some dummy data in our seed.rb file for all the models:

```Ruby
if User.count == 0
  User.create(username: "first", email: "first@test", password: "121212", password_confirmation: '121212' )
  puts "Created user"
end

if Category.count == 0
  categories = ['food', 'movies', 'hobbies', 'entertainment', 'health' ]

  categories.each do |category|
    Category.create(name: category)
  end

  puts "Created categories"
end

if Post.count == 0
  15.times do
    author = User.first
    Post.create(author: author, title: Faker::Lorem.words(number: 3).join(' '), content: Faker::Lorem.paragraph_by_chars(number: 2000, supplemental: false), category_id: rand(5) + 1)
  end
  puts "Created posts"
end
```

## Done;

## Http requests

next we need to generate the posts controller, then we need to write some basic tests. but before writing any test we need to config the post association in the factory bot for posts.rb

```Ruby

FactoryBot.define do
  factory :post do
    # this two association will recognise the foreign key
    association :author, factory: :user
    association :category
    title { "FirstTitle" }
    content { "My first content for the factory" }
  end
end
```

next we can write our test in request/posts_spec.rb:

```Ruby
  # in describe block the GET /index should change to /posts
  context "/posts" do
    before(:all) do
      create(:post)
    end
    before(:each) do
      get '/posts'
    end

    it "should have a respond of status 200 ok" do
      expect(response).to have_http_status(200)
    end

    it "should have the correct content-type" do
      expect(respose.content_type).to eq("application/json; charset=utf-8")
    end
    it "should have a body response of factory post" do
      expect(respose.body).to include("My first content for the factory")
    end
    it "should have a body response of factory category" do
      expect(respose.body).to include("Awesome Category")
    end
  end
```

When we done with our test, we can run rspec and all tests will fail; next step is to create a index action for posts:

if we don't use eager-load it will take more time to query all the posts including author usrename and categries, but with rails there is a way to work around that

```Ruby
def  index
  posts = Post.all.includes(:author, :category)
  render json: posts, include: {author: {only: :username}, category: {only: :name}}, status: 200
end
```

next we need to set our router in the route.rb for index action,

```Ruby
  get '/posts/
```

## Now if we run rspec we will pass all the tests'

---

next we need to write some test for single post with id, inside the request/posts_spec.rb we need to put:

```Ruby
describe "GET /posts/:id" do
    # context for the valid id
      context "valid post id" do

        before(:each) do
          get '/posts/1'
        end

        it "should response with status 200 ok" do
          expect(response).to have_http_status(200)
        end

        it "should have a right content-type" do
          expect(response.content_type).to eq("application/json; charset=utf-8")
        end

        it "should respond with factory content for post" do
          expect(response.body).to include('My first content for the factory')
        end
        it "should respond with factory content for category" do
          expect(response.body).to include('Awesome Category')
        end
      end
    # end of context for the valid id
    # Context for invalid post id
    context "invlid valid post id" do
      before(:each) do
        get '/posts/2'
      end

      it "should response with status 404" do
        expect(response).to have_http_status(404)
      end

      it "should have a right content-type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
      it "should respond with an error" do
        expect(response.body).to include('Unable to find post')
      end
    end
    # End Context for invalid post id

```

if we run rspec all tests will fail, we need to create a show action and route for show

```Ruby
def show
# you can set show params as before action too
  @post = Post.find(params[:id])
  render json: @post, include: {author: {only: :username}, category: {only: :name}}, status: 200
end
# you want to set_post as a private method you need to use exception handler like
private
  def set_post
    begin
      @post = Post.find(params[:id])
    rescue
      render json: {error: "Unable to find post"}
    end
  end
# you just need to call it as a before action
before_action :set_post, only: [:show]
```

if you run rspec all your tests will pass now. something to mention is just make sure to pass the

```Ruby
before(:all) do
 create(:post)
end
```

at the top of your RSpec.describe in the posts_spec.rb.

- All the test for the post id has been succesfully done

---
