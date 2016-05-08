class Boards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :maze, null: false, default: "."
      t.timestamps null: false
    end
  end
end
