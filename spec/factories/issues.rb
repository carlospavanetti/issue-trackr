FactoryBot.define do
  factory :issue do
    title { 'my issue' }
    content { 'this is a test issue.' }
    repository { create(:repository) }
    url { 'https://github.com/SophieDeBenedetto/learn-write/issues/1' }
  end
end
