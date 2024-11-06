# frozen_string_literal: true

class TasksController < ApplicationController
  respond_to :html, :turbo_stream

  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[index new edit create update]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true)
  end

  def new
    @task = Task.new
  end

  def show; end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('tasks.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('tasks.update.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
      format.html { redirect_to tasks_path, notice: t('tasks.destroy.success'), status: :see_other }
    end
  end

  def calendar
    @tasks = current_user.tasks
    @month = Date.today.beginning_of_month
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def set_categories
    @categories = Category.all
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :status, :category_id)
  end
end
