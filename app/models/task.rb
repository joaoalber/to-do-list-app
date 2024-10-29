class Task < ApplicationRecord
  STATUSES = %w[completed pending archived]

  scope :by_statuses, ->(statuses) do
    conditions = []

    conditions << "completed_at IS NOT NULL AND archived_at IS NULL" if statuses.include?("completed")
    conditions << "completed_at IS NULL AND archived_at IS NULL" if statuses.include?("pending")
    conditions << "archived_at IS NOT NULL" if statuses.include?("archived")

    where(conditions.join(" OR "))
  end

  def completed?
    completed_at.present?
  end

  def archived?
    archived_at.present?
  end

  def pending?
    !archived? && !completed?
  end

  def status
    return :archived if archived_at?
    return :completed if completed_at?

    :pending
  end
end
