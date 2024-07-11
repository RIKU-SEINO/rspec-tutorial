require 'rails_helper'

RSpec.describe "Projects", type: :system do

  scenario "user creates a new project" do
    user = FactoryBot.create(:user)
    sign_in user

    visit root_path

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

    visit root_path

    click_link "RSpec tutorial"

    click_link "Edit"

    fill_in "Name", with: "Edited RSpec tutorial"
    fill_in "Description", with: "Edited Description"

    click_button "Update Project"

    expect(page).to have_css "div.alert.alert-success", text: "Project was successfully updated."
    expect(project.reload.name).to eq "Edited RSpec tutorial"
  end
end
