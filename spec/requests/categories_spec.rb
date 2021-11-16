require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /categories" do
    # because our database is empty we need to before all tests create(:category) to have data in our database for the test
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
    it "should include in body Awesome Category" do
      expect(response.body).to include("Awesome Category")
    end
  end

end
