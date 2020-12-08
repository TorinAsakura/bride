# encoding: utf-8
require 'nokogiri'
require 'open-uri'

namespace :all_biz do
  desc "UA cities"
  task ua_cities: :environment do
    country = Country.where(name: 'Украина').first_or_create
    url = "http://www.ua.all.biz/guide-population?min_pop=25000"
    2.times.each do |p|
      url += "&page=#{p+1}" unless p.zero?
      doc = Nokogiri::HTML(open(url))
      doc.css('table[cellspacing="2"]').css('tr').each do |tr|
        if tr['class'] != 'menu'
          city_name = tr.css('td')[0].css('font a').text.strip
          region_name = tr.css('td')[1].css('a').text.strip.gsub('область', 'обл.')

          if city_name != region_name
            region = country.regions.where(name: region_name).first_or_create
          else
            region = country.regions.where('name ilike ?', "#{city_name}%").first || country.regions.where(name: 'АР Крым').first
            puts "Uniq city #{city_name}"
          end
          region.cities.where(name: city_name).first_or_create
        end
      end
    end
    puts "#{country.name} cities count #{country.cities.count}"
  end

  desc "BY cities"
  task by_cities: :environment do
    country = Country.where(name: 'Беларусь').first_or_create
    url = "http://www.by.all.biz/guide-population?min_pop=25000"
    doc = Nokogiri::HTML(open(url))
    doc.css('table[cellspacing="2"]').css('tr').each do |tr|
      if tr['class'] != 'menu'
        city_name = tr.css('td')[0].css('font a').text.strip
        region_name = tr.css('td')[1].css('a').text.strip.gsub('область', 'обл.')

        if city_name != region_name
          region = country.regions.where(name: region_name).first_or_create
        else
          region = country.regions.where('name ilike ?', "#{city_name}%").first
          puts "Uniq city #{city_name}"
        end
        region.cities.where(name: city_name).first_or_create
      end
    end
    puts "#{country.name} cities count #{country.cities.count}"
  end
end