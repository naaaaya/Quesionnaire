class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :email, uniqueness: true
  belongs_to :company
  has_many :surveys, through: :surveys_users
  has_many :surveys_users
  mount_uploader :image, ImageUploader
end
