require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'factory' do
    before(:all) do
      # diff between create and build is build create an object of the instance of the model but does not save it into the database, create will do the same an also it saves the inputs to the database
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
