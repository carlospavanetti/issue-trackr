class NotifierIssue < SimpleDelegator
  def send_email!
    UserMailer.issue_update_email(user, self).deliver_now
  end
end