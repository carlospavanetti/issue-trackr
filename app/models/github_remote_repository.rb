class GithubRemoteRepository
  def initialize(repo)
    @client = Octokit::Client.new(acccess_token: ENV['GITHUB_TOKEN'])
    @repo = repo
  end

  def create_issues
    @client.issues(
      "#{@repo.user.github_username}/#{@repo.name}"
    ).each do |issue|
      Issue.create(
        url: issue.html_url, opened_by: issue.user.login,
        status: issue.state, title: issue.title,
        content: issue.body, opened_on: issue.created_at,
        assignee: issue.assignee, repository: @repo
      )
    end
  end

  def create_webhook
    @client.create_hook(
      "#{@repo.user.github_username}/#{@repo.name}", 'web',
      {
        url: "#{ENV['ISSUE_TRACKR_APP_URL']}/webhooks/receive",
        content_type: 'json'
      }, events: ['issues'], active: true
    )
  end
end
