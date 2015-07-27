class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :cards, :card_id, :card_token
  end
end
