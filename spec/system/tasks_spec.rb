require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  scenario "user toggles a task", js: true do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "RSpec Tutorial", owner: user)
    task = project.tasks.create!(name: "Finish RSpec Tutorial")

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "RSpec Tutorial"
    check "Finish RSpec Tutorial"

    expect(page).to have_css "label#task_#{task.id}.completed"
    expect(task.reload).to be_completed

    uncheck "Finish RSpec Tutorial"
    expect(page).to_not have_css "label#task_#{task.id}.completed"
    expect(task.reload).to_not be_completed
  end

  scenario "user adds a task" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "RSpec Tutorial", owner: user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "RSpec Tutorial"

    expect {
      click_link "Add Task"
      fill_in "Name", with: "Finish RSpec Tutorial"
      click_button "Create Task"
      expect(page).to have_css "tr.task"
    }.to change(project.tasks, :count).by(1)
  end

  scenario "user deletes a task", js: true do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "RSpec Tutorial", owner: user)
    task = project.tasks.create!(name: "Finish RSpec Tutorial")

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "RSpec Tutorial"

    expect {
      click_link "Delete"
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_css "tr.task"
    }.to change(project.tasks, :count).by(-1)
  end
end
