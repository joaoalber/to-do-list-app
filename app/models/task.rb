class Task < ApplicationRecord
  validate :info_cannot_be_blank
  before_save :set_title

  belongs_to :user

  scope :by_statuses, ->(statuses) do
    conditions = []

    conditions << "completed_at IS NOT NULL AND archived_at IS NULL" if statuses.include?("completed")
    conditions << "completed_at IS NULL AND archived_at IS NULL" if statuses.include?("pending")
    conditions << "archived_at IS NOT NULL" if statuses.include?("archived")

    where(conditions.join(" OR "))
  end

  STATUSES = %w[completed pending archived]

  def completed? = completed_at.present?
  def archived? = archived_at.present?
  def pending? = !archived? && !completed?

  def status
    return :archived if archived_at?
    return :completed if completed_at?

    :pending
  end

  private

  def set_title
    return if title.present?
    return if description.blank?

    self.title = OpenAi::Client.new.call(description:).content

    # fallback in case API is not working
    self.title ||= description.split(" ").first(4).join(" ") + "..."
  end

  def info_cannot_be_blank
    if title.blank? && description.blank?
      errors.add(:info_cannot_be_blank, "Please provide at least a title or description")
    end
  end
end
