require "test_helper"

class GuestPhoneNumberTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:guest)
  end

  context "validations" do
    should validate_presence_of(:phone_number)
    should validate_uniqueness_of(:phone_number).scoped_to(:guest_id).case_insensitive
  end
end
