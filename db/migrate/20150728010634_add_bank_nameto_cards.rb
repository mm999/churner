class AddBankNametoCards < ActiveRecord::Migration
  def change
    add_column :cards, :bank_name, :string
    add_column :cards, :issue_date, :string
    add_column :cards, :annual_fee, :string
    add_column :cards, :credit_limit, :decimal, precision: 6, scale: 2
  end
end
