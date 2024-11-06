# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :title, :due_date, presence: true

  enum status: { "To Do": 'to_do', "In Progress": 'in_progress', "Completed": 'completed' }

  def self.ransackable_attributes(auth_object = nil)
    %w[title description due_date status category_id]
  end
end
