class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.string :currency, null: false
      t.string :status, null: false, default: 'pending'
      t.string :localized_description

      t.date :start_date, null: false
      t.date :end_date, null: false

      t.integer :number_of_guests, null: false, default: 0
      t.integer :number_of_nights, null: false, default: 0
      t.integer :number_of_adults, null: false, default: 0
      t.integer :number_of_children, null: false, default: 0
      t.integer :number_of_infants, null: false, default: 0

      t.float :total_price, null: false, precision: 10, scale: 2, default: 0.0
      t.float :security_price, null: false, precision: 10, scale: 2, default: 0.0
      t.float :payout_price, null: false, precision: 10, scale: 2, default: 0.0

      t.references :guest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
