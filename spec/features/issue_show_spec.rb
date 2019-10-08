require 'rails_helper'

RSpec.describe Issue, type: :feature do
  before(:each) do
    @user = User.create(name: 'Sophie DeBenedetto', email: 'sophie.debenedetto@gmail.com', github_username: 'sophiedebenedetto')
    @repo = Repository.create(name: 'learn-write', url: 'https://github.com/SophieDeBenedetto/learn-write', user: @user)
    @issue = Issue.create(title: 'my issue', content: 'this is a test issue.', repository: @repo, opened_on: DateTime.now, url: 'https://github.com/SophieDeBenedetto/learn-write/issues/1')
    sign_in
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  describe '#show' do
    it "displays an issues's title, content, github link and repo name" do
      visit issue_path(@issue)
      expect(page).to have_content('my issue')
      expect(page).to have_content('this is a test issue.')
      expect(page).to have_content('view on github')
      expect(page).to have_content('Learn Write')
    end

    context 'without an assignee' do
      it "displays 'n/a' for the assignee atttribute" do
        visit issue_path(@issue)
        expect(page).to have_content('assignee: n/a')
      end
    end

    context 'with an assignee' do
      it 'displays the name of the person assigned for the assignee atttribute' do
        @issue.assignee = 'antoinfive'
        @issue.save
        visit issue_path(@issue)
        expect(page).to have_content('assignee: antoinfive')
      end
    end
  end

  describe '#index' do
    it 'displays repo name as a capitalized title' do
      visit issues_path
      expect(page).to have_content('repo: Learn write')
    end
  end
end
