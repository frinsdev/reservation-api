require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  should "create reservation with payload format 1" do
    payload = {
      "start_date": "2021-03-12",
      "end_date": "2021-03-16",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "id": 1,
        "first_name": "Jane",
        "last_name": "Doe",
        "phone": "639123456789",
        "email": "jane_doe@example.com"
      },
      "currency": "AUD",
      "payout_price": "3800.00",
      "security_price": "500",
      "total_price": "4500.00"
    }

    assert_difference [ "Reservation.count", "Guest.count" ] do
      assert_difference "GuestPhoneNumber.count", 1 do
        post reservations_path, params: payload, as: :json
      end
    end

    assert_response :created

    reservation = Reservation.last
    assert_equal Date.parse(payload[:start_date]), reservation.start_date
    assert_equal Date.parse(payload[:end_date]), reservation.end_date
    assert_equal payload[:nights], reservation.number_of_nights
    assert_equal payload[:guests], reservation.number_of_guests
    assert_equal payload[:adults], reservation.number_of_adults
    assert_equal payload[:infants], reservation.number_of_infants
    assert_equal "accepted", reservation.status
    assert_equal "AUD", reservation.currency
    assert_equal payload[:payout_price].to_f, reservation.payout_price
    assert_equal payload[:security_price].to_f, reservation.security_price
    assert_equal payload[:total_price].to_f, reservation.total_price

    guest = reservation.guest
    assert_equal payload[:guest][:first_name], guest.first_name
    assert_equal payload[:guest][:email], guest.email
    assert_equal payload[:guest][:phone], guest.guest_phone_numbers.first.phone_number
  end

  should "create reservation with payload format 2" do
    payload = {
      "reservation": {
        "start_date": "2021-03-12",
        "end_date": "2021-03-16",
        "expected_payout_amount": "3800.00",
        "guest_details": {
          "localized_description": "4 guests",
          "number_of_adults": 2,
          "number_of_children": 2,
          "number_of_infants": 0
        },
        "guest_email": "john_doe@example.com",
        "guest_first_name": "John",
        "guest_id": 1,
        "guest_last_name": "Doe",
        "guest_phone_numbers": [
          "639123456789",
          "639987654321"
        ],
        "listing_security_price_accurate": "500.00",
        "host_currency": "AUD",
        "nights": 4,
        "number_of_guests": 4,
        "status_type": "accepted",
        "total_paid_amount_accurate": "4500.00"
      }
    }

    assert_difference [ "Reservation.count", "Guest.count" ] do
      assert_difference "GuestPhoneNumber.count", 2 do
        post reservations_path, params: payload, as: :json
      end
    end

    assert_response :created

    reservation = Reservation.last
    assert_equal Date.parse(payload[:reservation][:start_date]), reservation.start_date
    assert_equal Date.parse(payload[:reservation][:end_date]), reservation.end_date
    assert_equal payload[:reservation][:nights], reservation.number_of_nights
    assert_equal payload[:reservation][:number_of_guests], reservation.number_of_guests
    assert_equal payload[:reservation][:guest_details][:number_of_adults], reservation.number_of_adults
    assert_equal 0, reservation.number_of_infants
    assert_equal "accepted", reservation.status
    assert_equal "AUD", reservation.currency
    assert_equal payload[:reservation][:expected_payout_amount].to_f, reservation.payout_price
    assert_equal payload[:reservation][:listing_security_price_accurate].to_f, reservation.security_price
    assert_equal payload[:reservation][:total_paid_amount_accurate].to_f, reservation.total_price

    guest = reservation.guest
    assert_equal payload[:reservation][:guest_first_name], guest.first_name
    assert_equal payload[:reservation][:guest_email], guest.email
    assert_equal payload[:reservation][:guest_phone_numbers].count, guest.guest_phone_numbers.count
    assert_equal payload[:reservation][:guest_phone_numbers], guest.guest_phone_numbers.pluck(:phone_number)
  end

  should "return error with invalid payload" do
    post reservations_path, params: { invalid: "payload" }, as: :json
    assert_response :unprocessable_entity
  end
end
