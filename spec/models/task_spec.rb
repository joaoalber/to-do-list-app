require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    let(:task) { Task.new }

    context 'when both title and description are blank' do
      it 'is not valid' do
        task.valid?  # Trigger validations
        expect(task.errors[:info_cannot_be_blank]).to include("Please provide at least a title or description")
      end
    end

    context 'when title is present' do
      it 'is valid' do
        task.title = 'Task Title'
        task.description = nil
        expect(task).to be_valid
      end
    end

    context 'when description is present' do
      it 'is valid' do
        task.title = nil
        task.description = 'Task Description'
        expect(task).to be_valid
      end
    end

    context 'when both title and description are present' do
      it 'is valid' do
        task.title = 'Task Title'
        task.description = 'Task Description'
        expect(task).to be_valid
      end
    end
  end

  describe '#set_title' do
    let(:task) { Task.new(description: 'Need to go out with my dog today') }

    context 'when title is blank and description is present' do
      before do
        allow(OpenAi::Client).to receive_message_chain(:new, :call).and_return(double(content: 'Take dog for a walk'))
      end

      it 'sets the title using the OpenAi client' do
        task.save
        expect(task.title).to eq('Take dog for a walk')
      end
    end

    context 'when title is already present' do
      it 'does not change the title' do
        task.title = 'Existing Title'
        task.save
        expect(task.title).to eq('Existing Title')
      end
    end

    context 'when title and description are blank' do
      before do
        task.title = nil
        task.description = nil
      end

      it 'does not set the title' do
        task.save
        expect(task.title).to be_nil
      end
    end

    context 'when the OpenAi client fails to provide a title' do
      before do
        allow(OpenAi::Client).to receive_message_chain(:new, :call).and_return(double(content: nil))
      end

      it 'falls back to the first four words of the description' do
        task.save
        expect(task.title).to eq('Need to go out...')
      end
    end
  end

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

  describe '#archived?' do
    context 'when archived_at is present' do
      it 'returns true' do
        task = Task.new(archived_at: Time.now)
        expect(task.archived?).to be true
      end
    end

    context 'when archived_at is nil' do
      it 'returns false' do
        task = Task.new(archived_at: nil)
        expect(task.archived?).to be false
      end
    end
  end

  describe '#pending?' do
    context 'when neither completed_at nor archived_at is present' do
      it 'returns true' do
        task = Task.new(completed_at: nil, archived_at: nil)
        expect(task.pending?).to be true
      end
    end

    context 'when completed_at is present' do
      it 'returns false' do
        task = Task.new(completed_at: Time.now)
        expect(task.pending?).to be false
      end
    end

    context 'when archived_at is present' do
      it 'returns false' do
        task = Task.new(archived_at: Time.now)
        expect(task.pending?).to be false
      end
    end
  end

  describe '#status' do
    context 'when archived_at is present' do
      it 'returns :archived' do
        task = Task.new(archived_at: Time.now)
        expect(task.status).to eq(:archived)
      end
    end

    context 'when completed_at is present' do
      it 'returns :completed' do
        task = Task.new(completed_at: Time.now)
        expect(task.status).to eq(:completed)
      end
    end

    context 'when neither completed_at nor archived_at is present' do
      it 'returns :pending' do
        task = Task.new(completed_at: nil, archived_at: nil)
        expect(task.status).to eq(:pending)
      end
    end
  end

  describe '.by_statuses' do
    let!(:completed_task) { Task.create!(title: "Completed Task", completed_at: Time.now) }
    let!(:pending_task) { Task.create!(title: "Pending Task") }
    let!(:archived_task) { Task.create!(title: "Archived Task", archived_at: Time.now) }

    context 'when filtering by completed status' do
      it 'returns only completed tasks' do
        expect(Task.by_statuses([ 'completed' ])).to include(completed_task)
        expect(Task.by_statuses([ 'completed' ])).not_to include(pending_task, archived_task)
      end
    end

    context 'when filtering by pending status' do
      it 'returns only pending tasks' do
        expect(Task.by_statuses([ 'pending' ])).to include(pending_task)
        expect(Task.by_statuses([ 'pending' ])).not_to include(completed_task, archived_task)
      end
    end

    context 'when filtering by archived status' do
      it 'returns only archived tasks' do
        expect(Task.by_statuses([ 'archived' ])).to include(archived_task)
        expect(Task.by_statuses([ 'archived' ])).not_to include(completed_task, pending_task)
      end
    end

    context 'when filtering by multiple statuses' do
      it 'returns tasks matching any of the statuses' do
        expect(Task.by_statuses([ 'completed', 'pending' ])).to include(completed_task, pending_task)
        expect(Task.by_statuses([ 'completed', 'pending' ])).not_to include(archived_task)
      end
    end
  end
end
