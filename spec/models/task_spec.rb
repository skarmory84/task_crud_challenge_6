require 'rails_helper'

RSpec.describe Task, type: :model do

  it 'is not valid with empty name' do
    task = Task.new(name: nil, description: 'Valid description', status: :active)
    expect(task).to_not be_valid
  end

  it 'is not valid with symbols in the name' do
    task = Task.new(name: 'Symbol+name', description: 'Valid description', status: :active)
    expect(task).to_not be_valid
  end

  it 'is not valid with description longer than 100 chars' do
    long_desc = 'a' * 101
    task = Task.new(name: 'Valid name', description: long_desc, status: :active)
    expect(task).to_not be_valid
  end

  it 'is not valid if name is updated when status is in_progress' do
    task = create(:task, :in_progress)
    task.update(name: 'new valid name')
    expect(task).to_not be_valid
  end

  it 'is valid without description' do
    task = Task.new(name: 'Valid name', description: nil, status: :active)
    expect(task).to be_valid
  end

  it 'is valid with numbers in the name' do
    task = Task.new(name: 'Valid name 123', description: 'Valid description', status: :active)
    expect(task).to be_valid
  end
end
