FactoryGirl.define do
	sequence :email_address do |n|
    "fake_email#{n}@factory.com"
  end

	factory :user_client, class: User do
		email FactoryGirl.generate(:email_address)
		password "1234567890"
		password_confirmation "1234567890"
		association :profileable, factory: :client, strategy: :build
	end

	factory :user_firm, class: User do
		email {FactoryGirl.generate(:user_email)}
		password "1234567890"
		password_confirmation "1234567890"
		association :profileable, factory: :firm, strategy: :build
	end
end