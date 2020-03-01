class AddReferencesToTaskLists < ActiveRecord::Migration[5.2]
  def change
    add_reference :task_lists, :user, foreign_key: true
  end
end
