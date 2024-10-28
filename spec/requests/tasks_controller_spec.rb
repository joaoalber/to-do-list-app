require "rails_helper"

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    it "returns a success response" do
      get tasks_path
      expect(response).to be_successful
    end
  end

  describe "GET /tasks/new" do
    it "returns a success response" do
      get new_task_path
      expect(response).to be_successful
    end
  end

  describe "POST /tasks" do
    context "with valid params" do
      let(:valid_attributes) {
        { title: "Test Task", description: "This is a test task", due_date: Date.tomorrow }
      }

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

    context "with invalid params (past date)" do
      let(:invalid_attributes) {
        { due_date: Date.yesterday }
      }

      it "renders the form again" do
        post tasks_path, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Unless you are a time traveler, please provide a future date 😅")
      end
    end
  end

  describe "PATCH /tasks/:id" do
    let!(:task) { Task.create!(title: "Test Task", description: "This is a test task", due_date: Date.tomorrow) }

    it "toggles the completed status of the task" do
      patch task_path(task), params: { id: task.id }
      task.reload
      expect(task.completed_at).not_to be_nil

      patch task_path(task), params: { id: task.id }
      task.reload
      expect(task.completed_at).to be_nil
    end

    it "returns a success response with JSON" do
      patch task_path(task), params: { id: task.id }
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)["success"]).to be_truthy
    end
  end
end
