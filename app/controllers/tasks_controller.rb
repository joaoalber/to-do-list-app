class TasksController < ApplicationController
  def index
    if filter_params.present?
      @tasks = Task.by_statuses(filter_params)
    else
      @tasks = Task.where(archived_at: nil)
    end
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path
    else
      render turbo_stream: turbo_stream.update("task_modal", partial: "tasks/form", locals: { task: @task }), status: :unprocessable_entity
    end
  end

  def toggle_completed_at
    task = Task.find(params[:id])
    task.completed_at = task.completed? ? nil : Time.now
    task.archived_at = nil if task.archived?
    task.save!

    render json: { success: true, completed_at: task.completed_at }
  end

  def update
    @task = Task.find(params[:id])
    @task.attributes = task_params

    return redirect_to tasks_path unless @task.changed?

    if @task.save
      redirect_to tasks_path
    else
      render turbo_stream: turbo_stream.update("task_modal", partial: "tasks/form", locals: { task: @task }), status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end

  def archive_tasks
    Task.where.not(completed_at: nil).update_all(archived_at: Time.now, updated_at: Time.now)
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description, :title, :due_date)
  end

  def filter_params
    statuses = params["status"]

    # prevents injection of malicious values
    statuses&.all? { |status| Task::STATUSES.include?(status) } ? statuses : []
  end
end
