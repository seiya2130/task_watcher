class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :status
      t.datetime :dead_line
      t.references :task_list, foreign_key: true

      t.timestamps
    end
  end
end
