require 'rails_helper'

RSpec.describe Issue, type: :feature do
  describe '#show' do
    let(:user) { create(:user) }
    before(:each) do
      sign_in
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it 'displays owned repo names as a title' do
      @repo = Repository.create(name: 'learn-write', url: 'https://github.com/SophieDeBenedetto/learn-write', user: user)
      visit user_path(user)
      expect(page).to have_content('Learn Write')
    end

    context 'without phone number' do
      it 'displays add phone number message' do
        visit user_path(user)
        expect(page).to have_content('add your phone number to receive text message updates')
      end
    end

    context 'with phone number' do
      it "displays user's phone number" do
        user.update(phone_number: '914-841-4379')
        visit user_path(user)
        expect(page).to have_content('914-841-4379')
      end
    end
  end
end
