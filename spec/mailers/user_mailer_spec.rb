require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#issue_update_email' do
    let(:user) { create(:user) }
    let(:repo) { create(:repository, user: user) }
    let(:issue) { create(:issue, repository: repo) }

    it 'sends an email to a user when an issue on one of their repos has been created or changed' do
      email = UserMailer.issue_update_email(user, issue).deliver_now
      expect(ActionMailer::Base.deliveries.length).to eq(1)
      expect(email.from).to eq(['ghissue.trackr@gmail.com'])
      expect(email.to).to eq(['sophie.debenedetto@gmail.com'])
      expect(email.subject).to eq('an issue has been updated on GitHub')
    end
  end
end
