class CreateTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :templates do |t|
      t.string :name,        null: false
      t.string :period_type, null: false, default: "weekly"

      t.timestamps
    end
  end
end
