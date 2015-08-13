class RemoveBankNameFromCard < ActiveRecord::Migration
  def change
  	remove_column :cards, :bank_name
  end
end
