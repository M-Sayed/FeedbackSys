class State < ApplicationRecord
  belongs_to :feedback, touch: true
end
