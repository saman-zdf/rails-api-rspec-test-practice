FactoryBot.define do
  factory :post do
    # this two association will recognise the foreign key
    association :author, factory: :user
    association :category
    title { "FirstTitle" }
    content { "My first content for the factory" }
  end
end
