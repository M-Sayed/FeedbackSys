FactoryGirl.define do

    factory :company, class: Company do
      token { SecureRandom.hex }

      # after_create do |fb|
      #   FactoryGirl.create(:feedback, 5)
      # end
    end

    factory :feedback, class: Feedback do
      company
      priority "major"
      content  "content"
    end

    factory :invalid_p_feedback, class: Feedback do
      company
      priority "msh major"
    end

    factory :invalid_content_feedback, class: Feedback do
      company
      priority "major"
    end

    factory :state, class: State do
      feedback
      os "iphone"
      device "iphone 8"
      memory 1000
      storage 1000
    end
  end
