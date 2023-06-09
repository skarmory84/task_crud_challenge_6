require 'swagger_helper'

RSpec.describe 'Tasks API', type: :request do
  before do
    @user = create(:user, :admin)
  end

  path '/tasks' do
    get 'Get tasks' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :order_direction, in: :query, type: :string, nullable: true, enum: [nil, 'asc', 'desc'], description: 'Order by asc or desc'
      parameter name: :order_by, in: :query, type: :string, nullable: true, enum: [nil, 'id', 'name', 'description'], description: 'Order by field, id, name or description'
      parameter name: :page, in: :query, type: :integer, description: 'Page for pagination (started with 1)'
      parameter name: :per_page, in: :query, type: :integer, description: 'Tasks per page'

      response '200', 'get list' do
        let(:'Authorization') { @user.create_new_auth_token['Authorization'] }
        let(:order_direction) { 'asc' }
        let(:order_by) { 'id' }
        let(:page) { 1 }
        let(:per_page) { 25 }
        run_test!
      end
    end

    post 'Create a Task' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      let(:'Authorization') { @user.create_new_auth_token['Authorization'] }
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          status: { enum: ['active', 'inactive', 'in_progress'] }
        },
        required: ['name']
      }

      response '201', 'task created' do
        let(:task) { { name: 'Valid title', description: 'Valid description' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:task) { { name: 'Invalid-title'} }
        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    before do
      @task = create(:task, :active)
    end

    get 'Get a task' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      let(:'Authorization') { @user.create_new_auth_token['Authorization'] }
      parameter name: :id, in: :path, type: :string
      let(:id) { @task.id }

      response '200', 'task retreived' do
        run_test!
      end
    end

    put 'Update a task' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      let(:'Authorization') { @user.create_new_auth_token['Authorization'] }
      parameter name: :id, in: :path, type: :string
      let(:id) { @task.id }
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          status: { enum: ['active', 'inactive', 'in_progress'] }
        },
        required: ['name']
      }

      response '200', 'task created' do
        let(:task) { { name: 'Valid title', description: 'Valid description' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:task) { { name: 'Invalid-title'} }
        run_test!
      end
    end

    delete 'Delete a task' do
      tags 'Tasks'
      consumes 'application/json'
      security [Bearer: {}]
      let(:'Authorization') { @user.create_new_auth_token['Authorization'] }
      parameter name: :id, in: :path, type: :string
      let(:id) { @task.id }

      response '204', 'task deleted succesfully' do
        run_test!
      end
    end
  end
end
