class Company < ApplicationRecord
  has_secure_token
  has_many :feedbacks,
            foreign_key: :company_token,
            primary_key: :token

  def fbs_count
    Rails.cache.fetch(self) { feedbacks_count }
  end
end
