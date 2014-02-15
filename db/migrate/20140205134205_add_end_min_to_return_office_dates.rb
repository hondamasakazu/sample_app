class AddEndMinToReturnOfficeDates < ActiveRecord::Migration
  def change
    add_column :return_office_dates, :end_min, :string
  end
end
