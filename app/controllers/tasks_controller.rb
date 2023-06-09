class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ show update destroy ]
  load_and_authorize_resource

  # GET /tasks
  def index
    order_direction_hash = { asc: :asc, desc: :desc }
    order_by = params[:order_by] || :id
    order_direction = order_direction_hash[params[:order_direction]] || :asc
    page = params[:page]&.to_i || 1
    per_page = params[:per_page]&.to_i || Task.count
    
    @tasks = Task.limit(per_page).offset((page - 1) * per_page).order(order_by)

    render json: @tasks
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description, :status)
    end
end
