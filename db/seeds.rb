## Companies.
100.times do
  company = Company.create!
  10.times do
    feedback = Feedback.create(
      company: company,
      priority: rand(3)
    )
    State.create(
      feedback: feedback,
      os: 'iphone',
      device: 'iphone 8',
      storage: rand(10000),
      memory: rand(10000))
  end
end
