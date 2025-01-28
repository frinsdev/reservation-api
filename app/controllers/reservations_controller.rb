class ReservationsController < ApplicationController
  def create
    result = CreateReservationService.new(params.to_unsafe_h).call

    if result.success?
      render json: result.reservation, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end
end
