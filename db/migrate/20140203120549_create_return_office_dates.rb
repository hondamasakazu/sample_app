class CreateReturnOfficeDates < ActiveRecord::Migration
  def change
    create_table :return_office_dates do |t|
      t.string :return_date
      t.string :start_time
      t.string :end_time
      t.string :location

      t.timestamps
    end
  end
end
