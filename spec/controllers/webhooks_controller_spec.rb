require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  include SmsSpec::Helpers
  FIXTURES_PATH = Rails.root.join('spec', 'fixtures')

  describe '#receive' do
    let(:user) { create(:user, :with_phone_number) }
    let!(:repo) { create(:repository, user: user) }
    let(:payload) do
      JSON.parse(
        File.read("#{FIXTURES_PATH}/webhook_issue_payload.json"),
        symbolize_names: true
      )
    end

    context 'with a new issue' do
      it 'creates a new issue with the info in the payload from github' do
        VCR.use_cassette('webooks_receive') do
          post :receive, params: payload
          issue = Issue.first
          expect(repo.issues.count).to eq(1)
          expect(issue.url).to eq('https://github.com/SophieDeBenedetto/learn-write/issues/5')
          expect(issue.repository).to eq(repo)
          expect(issue.user).to eq(user)
        end
      end
    end

    context 'updating an existing issue' do
      it 'updates an existing issue with the info in the payload from github' do
        repo.issues.build(url: 'https://github.com/SophieDeBenedetto/learn-write/issues/5', content: 'testing')
        post :receive, params: payload
        expect(repo.issues.count).to eq(1)
        expect(repo.issues.first.content).to eq('THIS IS a TEST')
      end
    end

    context 'notifications' do
      it 'sends an email update to the user whose issue has been created/updated' do
        post :receive, params: payload
        email = ActionMailer::Base.deliveries.last
        expect(ActionMailer::Base.deliveries.length).to eq(1)
        expect(email.from).to eq(['ghissue.trackr@gmail.com'])
        expect(email.to).to eq(['sophie.debenedetto@gmail.com'])
        expect(email.subject).to eq('an issue has been updated on GitHub')
      end

      it 'sends a text message to the use whoe issue has been created/updated' do
        post :receive, params: payload
        text_message = open_last_text_message_for(user.phone_number)
        expect(text_message.body).to eq('test issue 2 has been updated. View it here: https://github.com/SophieDeBenedetto/learn-write/issues/5')
        expect(text_message.from).to eq('+1 914-363-0827')
        expect(text_message.number).to eq('234567890')
      end
    end
  end
end
