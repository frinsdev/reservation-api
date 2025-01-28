require "test_helper"

class GuestTest < ActiveSupport::TestCase
  context "associations" do
    should have_many(:guest_phone_numbers)
  end

  context "validations" do
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)
    should validate_presence_of(:email)
    should validate_uniqueness_of(:email)
  end
end
