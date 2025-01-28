class GuestPhoneNumber < ApplicationRecord
  belongs_to :guest

  validates :phone_number, presence: true, uniqueness: { scope: :guest_id }
end
