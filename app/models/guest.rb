class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :guest_phone_numbers, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
end
