# spec/controllers/tasks_controller_spec.rb

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  let!(:category) { create(:category) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @tasks and @categories' do
      get :index
      expect(assigns(:tasks)).to include(task)
      expect(assigns(:categories)).to include(category)
    end

    it 'filters tasks by search query' do
      task.update(title: 'Filtered Task')
      get :index, params: { q: { title_cont: 'Filtered' } }
      expect(assigns(:tasks)).to include(task)
      expect(assigns(:tasks).count).to eq(1)
    end
  end

  describe 'GET #new' do
    it 'assigns a new task and renders the new template' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
      expect(assigns(:categories)).to include(category)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new task and redirects to the tasks index' do
        expect {
          post :create, params: { task: { title: 'New Task', description: 'Description', due_date: Date.today, status: 'to_do', category_id: category.id } }
        }.to change(Task, :count).by(1)
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Task was successfully created.')
      end

      it 'creates a task with the correct attributes' do
        post :create, params: { task: { title: 'Attribute Test', description: 'Description', due_date: Date.today, status: 'to_do', category_id: category.id } }
        created_task = Task.last
        expect(created_task.title).to eq('Attribute Test')
        expect(created_task.description).to eq('Description')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new task' do
        expect {
          post :create, params: { task: { title: '', due_date: nil, category_id: category.id } }
        }.not_to change(Task, :count)
      end

      it 're-renders the new template with errors' do
        post :create, params: { task: { title: '', description: 'Description', due_date: nil, category_id: category.id } }
        expect(response).to render_template(:new)
        expect(response.status).to eq(422)
        expect(assigns(:task).errors.full_messages).to include("Title can't be blank", "Due date can't be blank")
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested task and renders the edit template' do
      get :edit, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
      expect(assigns(:categories)).to include(category)
      expect(response).to render_template(:edit)
    end

    it 'returns 404 for a non-existent task' do
      expect {
        get :edit, params: { id: 0 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the task and redirects to the tasks index' do
        patch :update, params: { id: task.id, task: { title: 'Updated Title' } }
        task.reload
        expect(task.title).to eq('Updated Title')
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Task was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the task and re-renders the edit template with errors' do
        patch :update, params: { id: task.id, task: { title: '' } }
        task.reload
        expect(task.title).not_to eq('')
        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
        expect(assigns(:task).errors.full_messages).to include("Title can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the task and redirects to the tasks index with a notice' do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
      expect(response).to redirect_to(tasks_path)
      expect(flash[:notice]).to eq('Task was successfully deleted.')
    end

    it 'responds with a turbo_stream format on delete' do
      delete :destroy, params: { id: task.id }, format: :turbo_stream
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  describe 'GET #calendar' do
    it 'assigns @tasks and sets @month to the beginning of the month' do
      get :calendar
      expect(assigns(:tasks)).to include(task)
      expect(assigns(:month)).to eq(Date.today.beginning_of_month)
    end

    it 'renders a calendar view with tasks due within the month' do
      task.update(due_date: Date.today.beginning_of_month)
      get :calendar
      expect(assigns(:tasks)).to include(task)
      expect(assigns(:month)).to eq(Date.today.beginning_of_month)
      expect(response).to render_template(:calendar)
    end
  end
end
