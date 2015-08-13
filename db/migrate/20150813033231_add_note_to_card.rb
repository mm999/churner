class AddNoteToCard < ActiveRecord::Migration
  def change
    add_column :cards, :note, :text
  end
end
