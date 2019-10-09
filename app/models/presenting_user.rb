class PresentingUser < SimpleDelegator
  def display_phone_number
    if phone_number.present?
      phone_number
    else
      '<i>add your phone number to receive text message updates</i>'.html_safe
    end
  end
end