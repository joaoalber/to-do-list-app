require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "returns a success response" do
      get tasks_path
      expect(response).to be_successful
    end

    context "with status filters" do
      let!(:completed_task) { Task.create!(title: "Completed Task", description: "Task completed", due_date: Date.tomorrow, completed_at: Time.now) }
      let!(:pending_task) { Task.create!(title: "Pending Task", description: "Task pending", due_date: Date.tomorrow, completed_at: nil) }

      it "filters tasks by status" do
        get tasks_path, params: { status: [ "completed" ] }
        expect(response.body).to include(completed_task.title)
        expect(response.body).not_to include(pending_task.title)
      end
    end
  end

  describe "GET /tasks/new" do
    it "returns a success response" do
      get new_task_path
      expect(response).to be_successful
    end
  end

  describe "GET /tasks/:id/edit" do
    let!(:task) { Task.create!(title: "Test Task", description: "Edit test", due_date: Date.tomorrow) }

    it "returns a success response" do
      get edit_task_path(task)
      expect(response).to be_successful
    end
  end

  describe "POST /tasks" do
    context "with valid params" do
      let(:valid_attributes) { { title: "Test Task", description: "This is a test task", due_date: Date.tomorrow } }

      it "creates a new Task" do
        expect {
          post tasks_path, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "redirects to the tasks list" do
        post tasks_path, params: { task: valid_attributes }
        expect(response).to redirect_to(tasks_path)
      end
    end
  end

  describe "PATCH /tasks/:id" do
    let!(:task) { Task.create!(title: "Test Task", description: "Update test", due_date: Date.tomorrow) }

    context "when task attributes are changed" do
      it "updates the task and redirects" do
        patch task_path(task), params: { task: { title: "Updated Title" } }
        task.reload
        expect(task.title).to eq("Updated Title")
        expect(response).to redirect_to(tasks_path)
      end
    end

    context "when task attributes are not changed" do
      it "does not save and redirects to tasks path" do
        patch task_path(task), params: { task: { title: task.title } }
        expect(response).to redirect_to(tasks_path)
      end
    end
  end

  describe "POST /tasks/:id/toggle_completed_at" do
    let!(:task) { Task.create!(title: "Toggle Completion", description: "Toggles completion status", completed_at: Date.today) }

    it "toggles the completed status of the task" do
      post toggle_completed_at_task_path(task), params: { id: task.id }
      task.reload
      expect(task.completed_at).to be_nil

      post toggle_completed_at_task_path(task), params: { id: task.id }
      task.reload
      expect(task.completed_at).not_to be_nil
    end

    it "returns a success response with JSON" do
      post toggle_completed_at_task_path(task), params: { id: task.id }
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)["success"]).to be_truthy
    end
  end

  describe "DELETE /tasks/:id" do
    let!(:task) { Task.create!(title: "Test Task", description: "Delete test", due_date: Date.tomorrow) }

    it "deletes the task and redirects to tasks list" do
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
      expect(response).to redirect_to(tasks_path)
    end
  end

  describe "POST /tasks/archive_tasks" do
    let!(:completed_task) { Task.create!(title: "Completed Task", description: "Archive test", due_date: Date.yesterday, completed_at: Time.now) }
    let!(:pending_task) { Task.create!(title: "Pending Task", description: "Pending archive test", due_date: Date.tomorrow, completed_at: nil) }

    it "archives only completed tasks and redirects" do
      post archive_tasks_tasks_path
      completed_task.reload
      pending_task.reload
      expect(completed_task.archived_at).not_to be_nil
      expect(pending_task.archived_at).to be_nil
      expect(response).to redirect_to(tasks_path)
    end
  end
end
