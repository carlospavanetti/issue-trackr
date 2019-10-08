FactoryBot.define do
  factory :user do
    name { 'Sophie DeBenedetto' }
    email { 'sophie.debenedetto@gmail.com' }
    github_username { 'sophiedebenedetto' }

    trait :with_phone_number do
      phone_number { '123-456-7890' }
    end
  end
end
