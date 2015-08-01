class Make < ActiveRecord::Migration
  def change
  	 change_column :cards, :annual_fee, 'decimal USING CAST(annual_fee AS decimal)'
  	 change_column :cards, :credit_limit, 'integer USING CAST(credit_limit AS integer)'
  end
end
