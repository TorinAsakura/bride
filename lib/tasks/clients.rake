namespace :clients do
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
          name = ns.first
          if name[0].eql?('c') && name.gsub('c', '').eql?(ns.last)
            n = ns.last.to_i
            break
          end
        end
      end

      count.to_i.times.each do |i|
        k = i+n+1
        email = "c#{k}@#{k}.#{country}"
        if User.with_deleted.find_by_email(email).blank?
          profileable = Client.create!(firstname: "Client", lastname: "Name ##{k}")
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
      puts "use 'rake clients:temp_emails country=/ua|ru/ count=N'"
    end
  end
end