class Feedback < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name "feedbacks"
  settings do
    mapping do
      indexes :company_token
      indexes :content
    end
  end
  enum priority: [:minor, :major, :critical]

  validates :content, presence: true

  has_one :state
  belongs_to :company,
              foreign_key: :company_token,
              primary_key: :token,
              counter_cache: true,
              touch: true

  accepts_nested_attributes_for :state

  before_create :set_number


  private

  def set_number
    self.number = company.feedbacks.count + 1
  end
end
