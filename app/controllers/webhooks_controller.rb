class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def receive
    unless params[:zen]
      issue = issue_from_url(issue_params[:html_url])
      issue.sync_with_webhook_payload!(issue_params)
      issue.send_message!
      issue.send_email!
    end
    head :no_content
  end

  private

  def issue_params
    params['issue']
  end

  def issue_from_url(url)
    WebhookUpdatingIssue.new(
      NotifierIssue.new(Issue.find_or_create_by(url: url))
    )
  end
end
