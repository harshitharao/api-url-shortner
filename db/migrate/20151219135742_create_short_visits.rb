class CreateShortVisits < ActiveRecord::Migration
  def change
    create_table :short_visits do |t|

      t.timestamps null: false
    end
  end
end
