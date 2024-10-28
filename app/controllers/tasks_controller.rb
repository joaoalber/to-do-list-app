class TasksController < ApplicationController
  require "ostruct"
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path
    else
      render turbo_stream: turbo_stream.update("task_modal", partial: "tasks/form", locals: { task: @task }), status: :unprocessable_entity
    end
  end

  # wip - change to toggle
  def update
    task = Task.find(params[:id])
    task.completed_at = task.completed? ? nil : Time.now
    task.save!

    render json: { success: true, completed_at: task.completed_at }
  end

  private

  def task_params
    params.require(:task).permit(:description, :title, :due_date)
  end
end
