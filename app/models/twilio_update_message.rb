class TwilioUpdateMessage
  def initialize(issue)
    @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
    @issue = issue
  end

  def send(owner)
    return if owner.phone_number.blank?

    @client.messages.create(
      to: owner.phone_number,
      from: twilio_number,
      body: "#{@issue.title} has been updated. View it here: #{@issue.url}"
    )
  end

  private

  def twilio_number
    "+1 #{ENV['TWILIO_NUMBER']}"
  end
end
