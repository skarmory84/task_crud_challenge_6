require 'rails_helper'

RSpec.describe "Task", type: :request do
  include Warden::Test::Helpers

  before do
    admin = create(:user, :admin)
    login_as(admin, scope: :user)
  end

  describe 'GET index' do
    before do
      create_list(:task, 30)
    end

    context 'without order or pagination' do
      it 'should list all tasks' do
        get '/tasks'
        binding.pry
      end
    end
  end
end
