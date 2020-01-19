class Task < ApplicationRecord
  belongs_to :task_list
  validates :name,  presence: true, length: { maximum: 20 }
  validate  :date_not_before_today

  def date_not_before_today
    errors.add(:dead_line, "は今日日付より後の日付を選択してください") if dead_line < Date.today
  end
end
