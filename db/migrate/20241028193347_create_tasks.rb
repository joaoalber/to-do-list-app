class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: true
      t.datetime :archived_at, null: true
      t.datetime :completed_at, null: true
      t.datetime :due_date, null: true
      t.timestamps
    end
  end
end
