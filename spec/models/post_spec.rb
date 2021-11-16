require 'rails_helper'

RSpec.describe Post, type: :model do
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
end
