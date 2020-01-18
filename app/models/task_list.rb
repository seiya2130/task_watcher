class TaskList < ApplicationRecord
    has_many :tasks
    validates :name,  presence: true, length: { maximum: 10 }
end
