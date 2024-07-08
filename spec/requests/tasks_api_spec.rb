require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  describe "GET /api/tasks" do
    it 'loads tasks' do
      user = FactoryBot.create(:user)
      project = FactoryBot.create(:project, name: "Sample Project", owner: user)
      task = project.tasks.create(name: "Sample Task")

      get api_tasks_path, params: {
        user_email: user.email,
        user_token: user.authentication_token
      }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      expect(json[0]["name"]).to eq "Sample Task"
    end
  end

  describe "POST /api/tasks" do
    it "creates a task" do
      user = FactoryBot.create(:user)
      project = FactoryBot.create(:project)
      task_attributes = FactoryBot.attributes_for(:task, project_id: project.id)

      expect {
        post api_tasks_path, params: {
          user_email: user.email,
          user_token: user.authentication_token,
          task: task_attributes
        }
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq task_attributes[:name]
    end
  end
end
