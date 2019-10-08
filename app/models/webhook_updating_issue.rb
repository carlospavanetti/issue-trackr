class WebhookUpdatingIssue < SimpleDelegator
  def sync_with_webhook_payload!(params)
    unless repository
      url_elements = params['repository_url'].split('/')
      repo_url = "https://github.com/#{url_elements[-2]}/#{url_elements[-1]}"
      repo = Repository.find_by(url: repo_url)
      update(repository: repo)
    end
    update(
      title: params['title'], content: params['body'],
      assignee: params['assignee'], status: params['state']
    )
  end
end