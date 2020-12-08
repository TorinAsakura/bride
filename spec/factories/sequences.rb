FactoryGirl.define do
	sequence :user_email do |uniq_number|
		"test_email#{uniq_number}@gmail.com"
	end
end