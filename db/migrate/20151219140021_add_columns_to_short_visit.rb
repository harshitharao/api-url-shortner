class AddColumnsToShortVisit < ActiveRecord::Migration
  def change
    add_column :short_visits, :short_url_id, :integer
    add_column :short_visits, :visitor_ip, :string
    add_column :short_visits, :visitor_city, :string
    add_column :short_visits, :visitor_state, :string
    add_column :short_visits, :visitor_country_iso2, :string
  end
end
