class AddStartMinToReturnOfficeDates < ActiveRecord::Migration
  def change
    add_column :return_office_dates, :start_min, :string
  end
end
