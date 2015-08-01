class ChangeColumnTypes < ActiveRecord::Migration
  def change
  	add_column :cards, :customer_id, :string
  	change_column :cards, :issue_date, 'date USING CAST(issue_date AS date)'
  end
end
