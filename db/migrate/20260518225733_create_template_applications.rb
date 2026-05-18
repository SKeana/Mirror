class CreateTemplateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :template_applications do |t|
      t.references :template, null: false, foreign_key: true
      t.string :period_type, null: false
      t.date   :period_start, null: false

      t.timestamps
    end

    add_index :template_applications, [:period_start, :period_type]
  end
end
