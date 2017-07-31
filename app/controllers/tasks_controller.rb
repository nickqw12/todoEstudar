class TasksController < ApplicationController
  def new
    @task = Task.new
    render :show_form
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    authorize! :create, @task
    save_task
  end

  def edit
    @task = Task.find(params[:id])
    authorize! :edit, @task
    render :show_form
  end

  def update
    @task = Task.find(params[:id])
    @task.assign_attributes(task_params)
    authorize! :update, @task
    save_task
  end

  def destroy
    @task = Task.find(params[:id])
    authorize! :destroy, @task
    @task.destroy
    reload_list
  end

  def complete
    @task = Task.find(params[:id])
    authorize! :complete, @task
    @task.assign_attributes({"completed" => !@task.completed})
    @task.save
    reload_list
  end

  def sort
    if session[:sort_column] == params[:column]
      session[:sort_direction] = !session[:sort_direction]
    else
      session[:sort_direction] = true
    end
    session[:sort_column] = params[:column]
    reload_list
  end

  def reload_list
    update_tasks_list
    render :reload
  end

  private
  def task_params
    params.require(:task).permit(:title, :note, :due, :completed)
  end

  private
  def save_task
    if @task.save
      update_tasks_list
      render :hide_form
    else
      render :show_form
    end
  end

  private
  def update_tasks_list
    if session[:sort_column] == "title"
      @tasks = Task.accessible_by(current_ability).order("lower(title)" + (session[:sort_direction] ? "" : " DESC")).all
    else
      @tasks = Task.accessible_by(current_ability).order(session[:sort_column] + (session[:sort_direction] ? "" : " DESC" ))
    end
  end

end
