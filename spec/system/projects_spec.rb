require 'rails_helper'

RSpec.describe "Projects", type: :system do

  scenario "user creates a new project" do
    user = FactoryBot.create(:user)
    sign_in user

    go_to_projects

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario "user edits a project" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "RSpec tutorial", owner: user)
    sign_in user

    go_to_projects
    go_to_edit_project "RSpec tutorial"

    edit_project "Edited RSpec tutorial", description: "Edited Description"

    expect_updated_project "Edited RSpec tutorial"
  end

  def go_to_projects
    visit root_path
  end

  def go_to_edit_project(name)
    visit root_path
    click_link name
    click_link "Edit"
  end

  def edit_project(name, description)
    fill_in "Name", with: name
    fill_in "Description", with: description
    click_button "Update Project"
  end

  def expect_updated_project(name)
    aggregate_failures do
      expect(page).to have_css "div.alert.alert-success", text: "Project was successfully updated."
      expect(page).to have_css "h1.heading", text: name
    end
  end
end
