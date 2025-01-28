require 'test_helper'

class CreateReservationServiceTest < ActiveSupport::TestCase
  setup do
    Rails.configuration.payload_mappings = YAML.load_file(
      Rails.root.join('config', 'payload_mappings.yml')
    )
    @v1_payload = {
      start_date: "2021-03-12",
      end_date: "2021-03-16",
      nights: 4,
      guests: 4,
      adults: 2,
      children: 2,
      infants: 0,
      status: "accepted",
      guest: {
        id: 1,
        first_name: "John",
        last_name: "Smith",
        phone: "639123456789",
        email: "johnsmith@example.com"
      },
      currency: "AUD",
      payout_price: "3800.00",
      security_price: "500",
      total_price: "4500.00"
    }

    @v2_payload = {
      reservation: {
        start_date: '2024-03-20',
        end_date: '2024-03-25',
        expected_payout_amount: '500.00',
        guest_details: {
          localized_description: 'Test description',
          number_of_adults: 2,
          number_of_children: 0,
          number_of_infants: 0
        },
        guest_email: 'janesmith@example.com',
        guest_first_name: 'Jane',
        guest_id: 1,
        guest_last_name: 'Smith',
        guest_phone_numbers: ['9876543210'],
        listing_security_price_accurate: '100.00',
        host_currency: 'USD',
        nights: 5,
        number_of_guests: 2,
        status_type: 'accepted',
        total_paid_amount_accurate: '600.00'
      }
    }
  end

  context 'with v1 payload format' do
    should 'create a new reservation successfully' do
      service = CreateReservationService.new(@v1_payload)
      result = service.call

      assert result.success?
      assert_not_nil result.reservation
      assert_empty result.errors

      reservation = result.reservation
      assert_equal Date.parse(@v1_payload[:start_date]), reservation.start_date
      assert_equal Date.parse(@v1_payload[:end_date]), reservation.end_date
      assert_equal @v1_payload[:nights], reservation.number_of_nights
      assert_equal @v1_payload[:status], reservation.status

      guest = reservation.guest
      assert_equal @v1_payload[:guest][:email], guest.email
      assert_equal @v1_payload[:guest][:first_name], guest.first_name
      assert_equal @v1_payload[:guest][:last_name], guest.last_name
      assert_equal [@v1_payload[:guest][:phone]], guest.guest_phone_numbers.pluck(:phone_number)
    end

    context 'with existing guest' do
      setup do
        @existing_guest = Guest.create!(
          email: @v1_payload[:guest][:email],
          first_name: @v1_payload[:guest][:first_name],
          last_name: @v1_payload[:guest][:last_name]
        )
      end

      should 'use existing guest and add new phone number' do
        service = CreateReservationService.new(@v1_payload)
        result = service.call

        assert result.success?
        assert_equal @existing_guest.id, result.reservation.guest_id
        assert_equal [@v1_payload[:guest][:phone]], @existing_guest.guest_phone_numbers.pluck(:phone_number)
      end

      context 'with existing phone number' do
        setup do
          @existing_guest.guest_phone_numbers.create!(phone_number: @v1_payload[:guest][:phone])
        end

        should 'not create duplicate phone number' do
          service = CreateReservationService.new(@v1_payload)
          result = service.call

          assert result.success?
          assert_equal 1, @existing_guest.guest_phone_numbers.count
        end
      end
    end
  end

  context 'with v2 payload format' do
    should 'create a new reservation successfully' do
      service = CreateReservationService.new(@v2_payload)
      result = service.call

      assert result.success?
      assert_not_nil result.reservation
      assert_empty result.errors

      reservation = result.reservation
      assert_equal Date.parse(@v2_payload[:reservation][:start_date]), reservation.start_date
      assert_equal Date.parse(@v2_payload[:reservation][:end_date]), reservation.end_date
      assert_equal @v2_payload[:reservation][:nights], reservation.number_of_nights
      assert_equal @v2_payload[:reservation][:status_type], reservation.status

      guest = reservation.guest
      assert_equal @v2_payload[:reservation][:guest_email], guest.email
      assert_equal @v2_payload[:reservation][:guest_first_name], guest.first_name
      assert_equal @v2_payload[:reservation][:guest_last_name], guest.last_name
      assert_equal [@v2_payload[:reservation][:guest_phone_numbers]].flatten, guest.guest_phone_numbers.pluck(:phone_number)
    end
  end

  context 'with invalid payload format' do
    should 'return error result' do
      service = CreateReservationService.new({ invalid: 'data' })
      result = service.call

      refute result.success?
      assert_nil result.reservation
      assert_equal ['Invalid payload format'], result.errors
    end
  end
end

