namespace :ideas do
  desc 'Remove duplicate idea tags'
  task remove_duplicate_tags: :environment do
    i = 0
    Idea.find_each do |idea|
      if idea.colors.count != idea.colors.uniq.count
        idea.colors.uniq.each do |color|
          if idea.color_taggings.where(tag_id: color.id).count > 1
            color_taggings = idea.color_taggings.where(tag_id: color.id).all
            color_taggings[1..-1].map(&:destroy)
            i+=1
          end
        end
      end
    end
    puts "Ideas with duplicate colors: #{i}"
  end
end