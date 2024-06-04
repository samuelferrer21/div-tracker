class CreatePaymentSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_schedules do |t|
      t.text :distribution_schedule

      t.timestamps
    end
  end
end
