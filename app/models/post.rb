class Post < ApplicationRecord
  belongs_to :category
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  validates :title, presence: true
  validates :content, presence:true
end
