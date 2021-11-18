require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'factory' do
    before(:all) do
      # diff between create and build is build create an object of the instance of the model but does not save it into the database, create will do the same an also it saves the inputs to the database

      # we also can change the existing data from factory if we want like below
      @category = build(:category, name: "This is our category")
    end
    it "has a valid factory" do 
      expect(@category).to be_valid
    end

    it "has the right name" do
      expect(@category.name).to eq("This is our category")
    end
  end
end
