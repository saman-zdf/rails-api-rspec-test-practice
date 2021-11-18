require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /auth/login" do

    before(:all) do
      @user = create(:user)
    end
    # context for the correct credentials
    context 'with correct credentials' do

      before(:each) do
        post '/auth/login', params: {auth: {email: "sam@test.com", password: "password1" }}
      end

      it 'should return 200 ok' do
        expect(response).to have_http_status(200)
      end

      it "should response a correct content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
      it "should response body a correct username and jwt" do
        expect(response.body).to include("Saman")
        expect(response.body).to include("jwt")
      end
      
    end
    # end of context for the correct credentials
    # context for testing the incorrect credentials
    context 'with incorrect credentials' do
      before(:each) do
        post '/auth/login', params: {auth: {email: "sam@test.com", password: "password1212" }}
      end

      it 'should return 404 ok' do
        expect(response).to have_http_status(422)
      end

      it "should response a correct content type" do
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
      it "should response body with error message" do
        expect(response.body).to include("Incorrect credentials!!!")
        
      end
    end
    # end of context for testing the incorrect credentials

  end
end
