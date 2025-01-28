class CreateReservationService
  Result = Struct.new(:success?, :reservation, :errors, keyword_init: true)

  def initialize(params)
    @params = params.with_indifferent_access
    @errors = []
  end

  def call
    ActiveRecord::Base.transaction do
      guest = find_or_create_guest
      create_phone_numbers(guest) if guest.persisted?
      reservation = guest.reservations.create!(reservation_params)

      Result.new(success?: true, reservation: reservation, errors: [])
    end

  rescue StandardError => e
    Result.new(success?: false, reservation: nil, errors: [@errors.presence || e.message])
  end

  private

  attr_reader :params, :errors

  def find_or_create_guest
    Guest.find_or_create_by(email: guest_params[:email]) do |guest|
      guest.first_name = guest_params[:first_name]
      guest.last_name = guest_params[:last_name]
    end
  end

  def create_phone_numbers(guest)
    guest_phone_numbers.each do |phone_number|
      guest.guest_phone_numbers.create(phone_number: phone_number)
    rescue ActiveRecord::RecordNotUnique
      next
    end
  end

  def guest_params
    {
      email: fetch_value(guest_mapping[:email])&.downcase,
      first_name: fetch_value(guest_mapping[:first_name]),
      last_name: fetch_value(guest_mapping[:last_name])
    }
  end

  def guest_phone_numbers
    phones = fetch_value(guest_mapping[:phone_numbers])

    phones.is_a?(Array) ? phones : [phones].compact
  end

  def reservation_params
    reservation_mapping.transform_values { |path| fetch_value(path) }
  end

  def fetch_value(path)
    return nil if path.nil?

    keys = path.split('.')
    keys.reduce(params) { |hash, key| hash&.[](key) }
  end

  def payload_format
    @payload_format ||= begin
      config = Rails.configuration.payload_mappings
      format = config['formats'].find { |_, format_config| matches_structure?(params, format_config['structure'].with_indifferent_access) }

      raise StandardError, 'Invalid payload format' unless format

      format[0]
    end
  end

  def matches_structure?(payload, structure)
    structure.all? do |key, expected|
      value = payload[key]
      return false unless value.present?

      if expected.is_a?(Hash) && !expected.empty?
        value.is_a?(Hash) && matches_structure?(value, expected.with_indifferent_access)
      else
        true
      end
    end
  end

  def guest_mapping
    Rails.configuration.payload_mappings.dig('formats', payload_format, 'mappings', 'guest').symbolize_keys
  end

  def reservation_mapping
    Rails.configuration.payload_mappings.dig('formats', payload_format, 'mappings', 'reservation').symbolize_keys
  end
end
