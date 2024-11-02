# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @categories = Category.all
    @tasks = current_user.tasks

    @tasks = @tasks.where('title ILIKE ?', "%#{params[:search]}%") if params[:search].present?

    @tasks = @tasks.where(category_id: params[:category_id]) if params[:category_id].present?

    @tasks = @tasks.where('due_date <= ?', params[:due_date]) if params[:due_date].present?
  end

  def new
    @task = Task.new
    @categories = Category.all
  end

  def create
    @task = current_user.tasks.build(task_params)
    @categories = Category.all
    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Task updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task deleted successfully.'
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status, :category_id)
  end
end
