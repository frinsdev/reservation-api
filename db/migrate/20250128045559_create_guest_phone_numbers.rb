class CreateGuestPhoneNumbers < ActiveRecord::Migration[8.0]
  def change
    create_table :guest_phone_numbers do |t|
      t.references :guest, null: false, foreign_key: true
      t.string :phone_number, null: false

      t.timestamps
    end

    add_index :guest_phone_numbers, [ :guest_id, :phone_number ], unique: true
  end
end
