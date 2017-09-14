class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :user, presence: true
  validates :email, presence: true, uniqueness: true
  belongs_to :company
  has_many :surveys, through: :surveys_users
  mount_uploader :image, ImageUploader
  has_many :surveys_users, dependent: :destroy

end
