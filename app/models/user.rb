class User < ActiveRecord::Base
  has_many :deliveries
  has_many :locations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable, :registerable, :recoverable, :validatable
  devise :database_authenticatable, :rememberable, :trackable

  validates :email, presence: true, uniqueness: true
  validates_format_of :email, :with => /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i

  validates :password, length: { minimum: 6 }, presence: true, on: :create
  validates :password_confirmation, length: { minimum: 6 }, presence: true, on: :create

  # enable update/edit to not require password
  validates :password, length: { minimum: 6 }, on: :update, allow_blank: true
  validates :password_confirmation, length: { minimum: 6 }, on: :update, allow_blank: :true

  validates :password, confirmation: true
end
