class QuestionsDigest
  def self.send_daily_digest
    User.find_each do |user|
      DigestMailer.dayly_digest(user).deliver_later
    end
  end
end
