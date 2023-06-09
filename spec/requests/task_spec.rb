require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  before(:all) do
    @admin = create(:user, :admin)
    @editor = create(:user, :editor)
    @normal = create(:user, :normal)
  end

  describe 'GET /index' do
    before do
      create_list(:task, 30)
    end

    context 'without order or pagination' do
      it 'lists all tasks' do
        get tasks_url, headers: @normal.create_new_auth_token
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
        get tasks_url, params: params, headers: @normal.create_new_auth_token
        records_count = JSON.parse(response.body).size
        expect(response).to have_http_status(:success)
        expect(records_count).to eq(5)
      end
    end
  end

  describe "GET /show" do
    let(:task) { create(:task) }

    context 'with existing resource' do
      it 'render the existing task' do
        get task_url(task), headers: @normal.create_new_auth_token
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
          get task_url(task.id + 1), headers: @normal.create_new_auth_token
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
