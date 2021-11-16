require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    context "/posts" do
      # when in the factory bot we add the association, when we create post as below we will get category and user with this post too
      before(:all) do
        create(:post)
      end
      before(:each) do
        get '/posts'
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
  end
end
