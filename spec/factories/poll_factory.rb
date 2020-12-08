FactoryGirl.define do
  factory :poll do |p|
    p.title "Test poll"
    p.images{
      [
        build(:poll_image), build(:poll_image)
      ]
    }
  end  
end