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
