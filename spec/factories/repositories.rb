FactoryBot.define do
  factory :repository do
    name { 'learn-write' }
    url { 'https://github.com/SophieDeBenedetto/learn-write' }
    user { create(:user) }
  end
end
