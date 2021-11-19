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

  # test creating post with token
  describe "POST /posts" do
    before(:all) do
      @post_count = Post.count 
      @new_user = create(:user, email:'newUser@test.com', username: "newUser")
    end

    context "test with token" do
      before(:each) do 
        token = JwtService.encode(@new_user)
        post '/posts', headers: {Authorization: "Bearer #{token}"}, params: {post: {title: "This is with new user", content: "I love Rsepc", category_id: 1}}
      end

      it "should respond with 201 created" do
        expect(response).to have_http_status(201)
      end
      it "should increase post count by 1" do
        expect(Post.count).to eq @post_count + 1
      end

      it "should contain post content" do
        expect(response.body).to include("This is with new user")
        expect(response.body).to include("newUser")
      end
    end

    context "test without token" do
      before(:each) do 
        post '/posts', params: {post: {title: "This is with new user", content: "I love Rsepc", category_id: 1}}
      end

      it "should respond with 401 Unathorizaed" do
        expect(response).to have_http_status(401)
      end
      it "should not increase post count by 1" do
        expect(Post.count).to eq @post_count 
      end

      it "should contain error message" do
        expect(response.body).to include("You must be logged in to do that!")
      end
    end

  end
  # end of test for creating post


  # test for updating a pot 
  describe "PUT /posts/:id" do
    before(:all) do
      @new_user = create(:user, email: "roya@test.com", username: "roay")
      @category = create(:category, name: "updating")
      @token = JwtService.encode(@new_user)
      post "/posts", headers: {Authorization: "Bearer #{@token}"}, params: {post: {title: "Saman's post", content: "This has been created by Saman", category_id: @category.id }}
    end

    context "update the post with token" do
      before(:each) do 
        put '/posts/2', headers: {Authorization: "Bearer #{@token}"}, params: {post: {title: "Saman's post has been edited", content: "This has been created by Saman and updated", category_id: @category.id }}
      end

      it "should respond with 201 accepted" do
        expect(response).to have_http_status(201)
      end

      it "should contain a correct content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "should contain a correct body" do
        expect(response.body).to include("Saman's post has been edited")
        expect(response.body).to include("roay")
      end
    end


    context "update the post without token" do
      before(:each) do 
        put '/posts/2', params: {post: {title: "Saman's post has been edited", content: "This has been created by Saman and updated", category_id: @category.id }}
      end

      it "should respond with 401 unauthorize" do
        expect(response).to have_http_status(401)
      end

      it "should contain a correct content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "should contain an error message" do
        expect(response.body).to include("You must be logged in to do that!")
      end
    end

  end

  # tests for destroy post 
  describe "DELETE /posts/:id" do 
    before(:all) do
      @new_user = create(:user, email: "sarah@test.com", username: "sarah")
      @category = create(:category, name: "deleting")
      @token = JwtService.encode(@new_user)
      post "/posts", headers: {Authorization: "Bearer #{@token}"}, params: {post: {title: "Sarah's post", content: "This has been created by Sarah", category_id: @category.id }}
    end

    context "delete with token" do
      before(:each) do
        delete '/posts/3', headers: {Authorization: "Bearer #{@token}"}
      end

      it "should respond with 202" do
        expect(response).to have_http_status(202)
      end

      it "should contain a correct content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "should contain correct content" do
        expect(response.body).to include("Sarah's post")
      end
    end

    context "delete with token" do
      before(:each) do
        delete '/posts/3'
      end

      it "should respond with 401 unauthorized" do
        expect(response).to have_http_status(401)
      end
      it "should contain an error message" do
        expect(response.body).to include("You must be logged in to do that!")
      end
    end
  end
end
