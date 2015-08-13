class ChangeColumnsBackToDecimal < ActiveRecord::Migration
  def up
  	change_column :cards, :annual_fee, :decimal, precision: 12, scale: 2
  	change_column :cards, :credit_limit, :decimal, precision: 12, scale: 2
  end

  def down
  	change_column :cards, :annual_fee, :money
  	change_column :cards, :credit_limit, :money
  end
end
