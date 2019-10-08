class NotifierIssue < SimpleDelegator
  def send_email!
    UserMailer.issue_update_email(user, self).deliver_now
  end

  def send_message!
    owner = repository.user
    TwilioUpdateMessage.new(self).send(owner) if owner.phone_number
  end
end
