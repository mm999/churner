class ChangeColumnsToMoney < ActiveRecord::Migration
  def up
  	change_column :cards, :annual_fee, :money
  	change_column :cards, :credit_limit, :money
  end

  def down
  	change_column :cards, :annual_fee, :decimal
  	change_column :cards, :credit_limit, :integer
  end
end
