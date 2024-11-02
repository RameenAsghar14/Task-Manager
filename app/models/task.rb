# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :due_date, presence: true

  enum status: { "To Do": 'to_do', "In Progress": 'in_progress', "Completed": 'completed' }
end
