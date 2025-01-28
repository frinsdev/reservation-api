class Reservation < ApplicationRecord
  belongs_to :guest

  validates :start_date, :end_date, :currency, :status, :number_of_guests,
    :number_of_nights, :number_of_adults, :number_of_children, :number_of_infants,
    :total_price, :security_price, :payout_price, presence: true
end

