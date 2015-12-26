class AddVisitorCountryToShortVisit < ActiveRecord::Migration
  def change
    add_column :short_visits, :visitor_country, :string
  end
end
