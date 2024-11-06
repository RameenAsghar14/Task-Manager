# spec/models/task_spec.rb
require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  it "is valid with valid attributes" do
    expect(task).to be_valid
  end
end
