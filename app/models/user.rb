class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates_format_of :username, with: /^[^@]+$/, multiline: true, message: "Username cannot contain @ symbol"
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  has_many :posts

  scope :login, -> (input) {User.where(username: input).or(User.where(email: input))}
end
