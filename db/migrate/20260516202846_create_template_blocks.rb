class CreateTemplateBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :template_blocks do |t|
      t.references :template, null: false, foreign_key: true
      t.string  :title,            null: false
      t.text    :notes
      t.string  :color,            null: false, default: "#3b82f6"
      t.integer :offset_days,      null: false, default: 0
      t.integer :start_minute,     null: false, default: 540   # 09:00
      t.integer :duration_minutes, null: false, default: 60

      t.timestamps
    end
  end
end
