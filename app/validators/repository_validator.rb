class RepositoryValidator < ActiveModel::Validator
  def validate(record)
    username = record.user.github_username
    repo_owner = record.url.split('/')[-2]
    return if username.downcase == repo_owner.downcase

    record.errors[:ownership] <<
      'you must be the owner of this repo in order to add it'
  end
end
