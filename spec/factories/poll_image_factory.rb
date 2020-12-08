include ActionDispatch::TestProcess

FactoryGirl.define do
	factory :poll_image do
		image {fixture_file_upload("spec/files/test_image_1.jpg", "image/jpeg")}
	end
end