desc 'Delete all unconfirmed users after 14 days'
task delete_unconfirmed_users: :environment do
  users = User.where('confirmed_at is NULL AND (confirmation_sent_at is NULL OR confirmation_sent_at <= ?)', Time.now - 14.day)
  users.each do |user|
    user.destroy
  end
end
