require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /auth/login" do

    before(:all) do
      @user = create(:user)
    end
    # context for the correct credentials
    context "with correct credentials" do 
      # I can change the params data by passing new params data like below, it will change it with the existing data from factory
      before(:each) do
        post '/auth/login', params: {auth: {email: "sam@test.com", password: "password1"}}
      end

      it "should respond with 200 ok" do
        expect(response).to have_http_status(200)
      end
      it "should respond with correct content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "should respond with correct username and jwt" do
        # whatever you have as a username in your factory or you can overwrite that by passing as above
        expect(response.body).to include("Saman")
        expect(response.body).to include("jwt")
      end
    end
    # context for incorrect credentials
    context "with incorrect credentials" do 
      # I can change the params data by passing new params data like below, it will change it with the existing data from factory
      before(:each) do
        post '/auth/login', params: {auth:{email: "sam@test.com", password: "incorrectPass"}}
      end

      it "should respond with 422 ok" do
        expect(response).to have_http_status(422)
      end
      it "should respond with correct content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end

      it "should respond with error message" do
        expect(response.body).to include("Incorrect credentials!!!")
      end
    end
    # end of context for testing the incorrect credentials

  end
end
