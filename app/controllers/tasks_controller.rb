# frozen_string_literal: true

class TasksController < ApplicationController
  respond_to :html, :turbo_stream

  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @categories = Category.all
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
  end

  def new
    @task = Task.new
    @categories = Category.all
  end

  def show
    # This action will use the @task set by the set_task before_action
  end

  def create
    @task = current_user.tasks.build(task_params)
    @categories = Category.all
    if @task.save!
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    @categories = Category.all
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
      format.html { redirect_to tasks_path, notice: 'Task was successfully deleted.', status: :see_other }
    end
  end

def calendar
  @tasks = Task.all
  @month = Date.today.beginning_of_month
end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status, :category_id)
  end
end
