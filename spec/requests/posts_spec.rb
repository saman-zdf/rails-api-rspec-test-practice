require 'rails_helper'

RSpec.describe "Posts", type: :request do
  # when in the factory bot we add the association, when we create post as below we will get category and user with this post too, you need to pass beofore(:all to create post inside the RSpec.describe at the very top for all your describe and context block)
  before(:all) do
    create(:post)
  end
  describe "GET /posts" do
    context "/posts" do
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
    
  end

end
