class CreateTimeBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :time_blocks do |t|
      t.string   :title,    null: false
      t.text     :notes
      t.string   :color,    null: false, default: "#3b82f6"
      t.datetime :start_at, null: false
      t.datetime :end_at,   null: false

      t.timestamps
    end

    add_index :time_blocks, :start_at
    add_index :time_blocks, :end_at
  end
end
