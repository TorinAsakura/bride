# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Firm.all.each {|firm| firm.banner_album ||= Album.create(:name=>"Баннеры",:system=>1); firm.save }

# Firm.all.each {|firm| firm.destroy unless firm.user }

# Firm.all.each {|firm| firm.cities << City.first if firm.cities.empty? }

# Client.all.each {|client| client.destroy unless client.user }

# Page.where(:system => true).where(:name => 'photo').each do |page|
#   page.update_attributes(:name => 'albums')
# end
