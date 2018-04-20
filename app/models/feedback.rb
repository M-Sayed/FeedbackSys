class Feedback < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name "feedbacks"
  settings do
    mapping do
      indexes :token
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


  # def to_indexed_json
  #   to_json(include: { state: {only: [:os, :device, :memory, :storage]}})
  # end


  private

  def set_number
    self.number = company.feedbacks.count + 1
  end
end
