namespace :firms do
  desc 'Firms with temp emails'
  task temp_emails: :environment do
    if (country = ENV['country']).present? && (count = ENV['count']).present?
      password = '23456'
      password = case country
                   when 'ua'
                     password+'7'
                   when 'ru'
                     '1'+password
                   else
                     password
                 end

      n = 0
      if (users = User.with_deleted.where('email like ?',"%.#{country}").order('id desc').all).present?
        users.each do |user|
          e = user.email
          ns = e.split('.')[0].split('@')
          if ns.first.eql?(ns.last)
            n = ns.first.to_i
            break
          end
        end
      end

      count.to_i.times.each do |i|
        k = i+n+1
        email = "#{k}@#{k}.#{country}"
        if User.with_deleted.find_by_email(email).blank?
          profileable = Firm.create!(name: "Temp Name ##{k}")
          user = User.new({
                              login: email,
                              email: email,
                              password: password,
                              profileable: profileable
                          }, without_protection: true)
          user.skip_confirmation!
          user.valid?
          user.save!
          user.add_role :moderator, profileable
        end
      end
    else
      puts "use 'rake firms:temp_emails country=/ua|ru/ count=N'"
    end
  end

  desc 'Firms count in country cities'
  task count_in_cities: :environment do
    if (country_id = ENV['country']).present? && (firm_catalog_id = ENV['firm_catalog']).present?
      country = Country.find(country_id)
      cities = country.cities.enabled_for_firms
      firm_catalog = FirmCatalog.find(firm_catalog_id)
      puts "'#{firm_catalog.name}'"
      cities.each do |city|
        c = firm_catalog.firms.by_city(city).count
        puts "    #{city.name} -> #{c}"
      end
    else
      puts "use 'rake firms:count_in_cities  country=COUNTRY_ID firm_catalog= FIRM_CATALOG_ID'"
    end
  end
end