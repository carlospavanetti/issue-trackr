require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#issue_update_email' do
    let(:user) { create(:user) }
    let(:repo) { create(:repository, user: user) }
    before(:each) do
      @issue = Issue.create(title: 'my issue', content: 'this is a test issue.', repository: repo, opened_on: DateTime.now, url: 'https://github.com/SophieDeBenedetto/learn-write/issues/1')
    end

    it 'sends an email to a user when an issue on one of their repos has been created or changed' do
      email = UserMailer.issue_update_email(user, @issue).deliver_now
      expect(ActionMailer::Base.deliveries.length).to eq(1)
      expect(email.from).to eq(['ghissue.trackr@gmail.com'])
      expect(email.to).to eq(['sophie.debenedetto@gmail.com'])
      expect(email.subject).to eq('an issue has been updated on GitHub')
    end
  end
end
