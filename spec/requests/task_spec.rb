require 'rails_helper'

RSpec.describe "Task", type: :request do
  include Warden::Test::Helpers

  before(:all) do
    @admin = create(:user, :admin)
  end

  describe 'GET index' do
    before do
      create_list(:task, 30)
    end

    context 'without order or pagination' do
      it 'should list all tasks' do
        get '/tasks', headers: @admin.create_new_auth_token
        records_count = JSON.parse(response.body).size
        expect(response).to have_http_status(:success)
        expect(records_count).to eq(30)
      end
    end

    context 'with pagination and order' do
      it 'should list last 5 tasks of the last page' do
        params = {
          order_by: :name,
          order_direction: :desc,
          page: 2,
          per_page: 25
        }
        get '/tasks', params: params, headers: @admin.create_new_auth_token
        records_count = JSON.parse(response.body).size
        expect(response).to have_http_status(:success)
        expect(records_count).to eq(5)
      end
    end
  end
end
