require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#completed?' do
    context 'when completed_at is present' do
      it 'returns true' do
        task = Task.new(completed_at: Time.now)
        expect(task.completed?).to be true
      end
    end

    context 'when completed_at is nil' do
      it 'returns false' do
        task = Task.new(completed_at: nil)
        expect(task.completed?).to be false
      end
    end
  end

  describe 'validations' do
    context 'when due_date is in the past' do
      it 'is not valid and adds an error' do
        task = Task.new(due_date: 1.day.ago)
        task.valid?
        expect(task.errors[:due_date]).to include("Unless you are a time traveler, please provide a future date 😅")
      end
    end

    context 'when due_date is in the future' do
      it 'is valid' do
        task = Task.new(due_date: 1.day.from_now)
        task.valid?
        expect(task.errors[:due_date]).to be_empty
      end
    end

    context 'when due_date is nil' do
      it 'is valid' do
        task = Task.new(due_date: nil)
        task.valid?
        expect(task.errors[:due_date]).to be_empty
      end
    end
  end
end
