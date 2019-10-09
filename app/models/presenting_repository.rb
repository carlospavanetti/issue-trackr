class PresentingRepository < SimpleDelegator
  def display_name
    name.gsub('-', ' ').titleize
  end
end