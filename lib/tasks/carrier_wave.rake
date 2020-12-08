namespace :carrier_wave do
  namespace :photo do
    desc 'Recreate Photo usual_path versions'
    task usual_path: :environment do
      puts "All Photo count: #{Photo.where('usual_path is not null').count}"
      i = 1
      Photo.where('usual_path is not null').find_each do |photo|
        photo.usual_path.recreate_versions!
        photo.save
        puts "Index #{i}" if (i % 50).zero?
        i+=1
      end
    end
  end
end