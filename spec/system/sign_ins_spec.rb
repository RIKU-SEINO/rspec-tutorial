require 'rails_helper'

RSpec.describe "Sign-ins", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  #ユーザーログイン
  scenario "user signs in" do
    visit root_path
    click_link "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect {
      GeocodeUserJob.perform_later(user)
    }.to have_enqueued_job.with(user)
  end
end
