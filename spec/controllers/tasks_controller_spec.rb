require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:all) do
    @admin = create(:user, :admin)
    @editor = create(:user, :editor)
    @normal = create(:user, :normal)
  end

  describe 'GET /index' do
    before do
      create_list(:task, 30)
      request.headers.merge!(@normal.create_new_auth_token)
    end

    context 'without order or pagination' do
      it 'lists all tasks' do
        get :index
        records_count = JSON.parse(response.body).size
        expect(response).to be_successful
        expect(records_count).to eq(30)
      end
    end

    context 'with pagination and order' do
      it 'lists the last 5 tasks of the last page' do
        params = {
          order_by: :name,
          order_direction: :desc,
          page: 2,
          per_page: 25
        }
        get :index, params: params
        records_count = JSON.parse(response.body).size
        expect(response).to have_http_status(:success)
        expect(records_count).to eq(5)
      end
    end
  end

  describe "GET /show" do
    let(:task) { create(:task) }

    before do
      request.headers.merge!(@normal.create_new_auth_token)
    end

    context 'with existing resource' do
      it 'render the existing task' do
        get :show, params: { id: task.id }
        expect(response).to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response['name']).not_to be_nil
        expect(json_response['description']).not_to be_nil
        expect(json_response['status']).not_to be_nil
      end
    end

    context 'with invalid resource' do
      it 'raise record not found exception' do
        expect do
          get :show, params: { id: task.id + 1 }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid user' do 
      before do
        request.headers.merge!(@editor.create_new_auth_token)
      end

      context 'with valid parameters' do
        it 'creates new a task' do
          params = {
            task: {
              name: 'Valid name',
              description: 'Valid description',
              status: :active
            }
          }
          post :create, params: params

          expect(response).to have_http_status(:created)
          expect(Task.count).to eq(1)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new task' do
          params = {
            task: {
              name: 'Invalid_name',
              description: 'a' * 101,
            }
          }
          post :create, params: params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(Task.count).to eq(0)
        end
      end
    end

    context 'with invalid user' do
      before do
        request.headers.merge!(@normal.create_new_auth_token)
      end
      it 'does not creates a new task' do
        params = {
          task: {
            name: 'Valid name',
            description: 'Valid description',
            status: :active
          }
        }
        post :create, params: params, as: :json

        expect(response).to have_http_status(:forbidden)
        expect(Task.count).to eq(0)
      end
    end
  end

  describe "PUT /update" do
    let(:task) { create(:task) }
    
    context 'with valid user' do 
      before do
        request.headers.merge!(@editor.create_new_auth_token)
      end

      context 'with valid parameters' do
        it 'updates a task' do
          params = {
            id: task.id,
            task: {
              name: 'New valid name',
              description: 'New valid description',
              status: :active
            }
          }
          put :update, params: params

          expect(response).to have_http_status(:ok)
          task.reload
          expect(task.name).to eq('New valid name')
          expect(task.description).to eq('New valid description')
        end
      end

      context 'with invalid parameters' do
        it 'does not update a task' do
          params = {
            id: task.id,
            task: {
              name: 'Invalid_name',
              description: 'Invalid_description',
            }
          }
          put :update, params: params

          expect(response).to have_http_status(:unprocessable_entity)
          task.reload
          expect(task.name).not_to eq('Invalid_name')
          expect(task.description).not_to eq('Invalid_description')
        end
      end

      context 'update name when in_progress' do
        it 'does not update a task' do
          in_progress_task = create(:task, :in_progress)
          params = {
            id: in_progress_task.id,
            task: {
              name: 'Another valid name',
            }
          }
          put :update, params: params
          expect(response).to have_http_status(:unprocessable_entity)
          in_progress_task.reload
          expect(in_progress_task.name).not_to eq('Another valid name')
        end
      end
    end

    context 'with invalid user' do
      before do
        request.headers.merge!(@normal.create_new_auth_token)
      end

      it 'does not updates a task' do
        params = {
          id: task.id,
          task: {
            name: 'Valid name',
            description: 'Valid description',
            status: :active
          }
        }
        put :update, params: params, as: :json

        expect(response).to have_http_status(:forbidden)
        expect(task.name).not_to eq('Valid name')
        expect(task.description).not_to eq('Valid description')
      end
    end
  end

  describe 'DELETE /destroy' do    
    before do
      request.headers.merge!(@admin.create_new_auth_token)
    end

    context 'with valid user' do
      it 'destroys the requested task' do
        task = create(:task)
        params = { id: task.id }
        delete :destroy, params: params

        expect(response).to have_http_status(:no_content)
        expect(Task.count).to eq(0)
      end
    end

    context 'with invalid user' do
      before do
        request.headers.merge!(@normal.create_new_auth_token)
      end

      it 'does not destroys the requested task' do
        task = create(:task)
        params = { id: task.id }
        delete :destroy, params: params, as: :json

        expect(response).to have_http_status(:forbidden)
        expect(Task.count).to eq(1)
      end
    end
  end
end
