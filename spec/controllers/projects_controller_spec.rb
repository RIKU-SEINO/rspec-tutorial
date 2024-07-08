require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
    describe "#index" do

        before do
            @user = FactoryBot.create(:user)
        end

        it "resnponds successfully" do
            sign_in @user
            get :index
            expect(response).to be_successful
        end
        it "returns a 200 response" do
            sign_in @user
            get :index
            expect(response).to have_http_status "200"
        end
    end
end
