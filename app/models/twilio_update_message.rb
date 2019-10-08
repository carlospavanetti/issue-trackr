class TwilioUpdateMessage
  def initialize(issue)
    @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
    @issue = issue
  end

  def send(owner)
    @client.messages.create(
      to: owner.phone_number,
      from: "+1 #{ENV['TWILIO_NUMBER']}",
      body: "#{@issue.title} has been updated. View it here: #{@issue.url}"
    )
  end
end
