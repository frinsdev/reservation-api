require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:guest)
  end

  context "validations" do
    should validate_presence_of(:start_date)
    should validate_presence_of(:end_date)
    should validate_presence_of(:currency)
    should validate_presence_of(:status)
    should validate_presence_of(:number_of_guests)
    should validate_presence_of(:number_of_nights)
    should validate_presence_of(:number_of_adults)
    should validate_presence_of(:number_of_infants)
    should validate_presence_of(:total_price)
    should validate_presence_of(:security_price)
    should validate_presence_of(:payout_price)
  end
end
