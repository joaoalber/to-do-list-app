class Task < ApplicationRecord
  validate :check_date, on: :create

  def completed?
    completed_at.present?
  end

  def check_date
    if due_date&.past?
      errors.add(:due_date, "Unless you are a time traveler, please provide a future date 😅")
    end
  end
end
