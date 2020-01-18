class TaskList < ApplicationRecord
    has_many :tasks, dependent: :destroy
    validates :name,  presence: true, length: { maximum: 10 }
end
