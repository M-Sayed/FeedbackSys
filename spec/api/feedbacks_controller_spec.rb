require 'rails_helper'

RSpec.describe "Feedbacks Api" , :type => :request do
  before :all do
    @company          = FactoryGirl.create(:company)
    @feedback         = FactoryGirl.create(:feedback, company: @company)
    @state            = FactoryGirl.create(:state, feedback: @feedback)
  end

  describe "POST /feedbacks" do
    it "creates new feedback" do
      data =  { feedback: FactoryGirl.attributes_for(:feedback)
                  .merge(state_attributes: FactoryGirl.attributes_for(:state)),
                company_token: @company.token }

      post "/feedbacks", :params => data
      expect(response.status).to eq(201)
    end

    it "responds with feedback number" do
      data =  { feedback: FactoryGirl.attributes_for(:feedback)
                  .merge(state_attributes: FactoryGirl.attributes_for(:state)),
                company_token: @company.token }

      post "/feedbacks", :params => data
      expect(JSON.parse(response.body)["number"]).to \
        eq(@company.reload.feedbacks.count)
    end

    it "content should exist" do
      data =  { feedback: FactoryGirl.attributes_for(:invalid_content_feedback)
                  .merge(state_attributes: FactoryGirl.attributes_for(:state)),
                company_token: @company.token }

      post "/feedbacks", :params => data
      expect(response.status).to eq(422)
    end

    it "feedback should be created" do
      data =  { feedback: FactoryGirl.attributes_for(:feedback)
                  .merge(state_attributes: FactoryGirl.attributes_for(:state)),
                company_token: @company.token }

      expect {
        post "/feedbacks", :params => data
      }.to change { Feedback.count }
    end

    it "state should be created" do
      data =  { feedback: FactoryGirl.attributes_for(:feedback)
                  .merge(state_attributes: FactoryGirl.attributes_for(:state)),
                company_token: @company.token }

      expect {
        post "/feedbacks", :params => data
      }.to change { State.count }
    end

    # umm, this is not correct?
    it "does not create feedback with unknown priority" do
      data =  { feedback: FactoryGirl.attributes_for(:invalid_p_feedback)
                  .merge(state_attributes: FactoryGirl.attributes_for(:state)),
                company_token: @company.token }

      post "/feedbacks", :params => data
      expect(response.status).to eq(500)
    end
  end

  describe "GET /feedbacks/:number" do
    it "get feedback by number" do
      get "/feedbacks/#{@feedback.number}",
        params: {company_token: @company.token}
      expect(JSON.parse(response.body)['id']).to eq(@feedback.id)
    end

    it "responds 404 if the feedback doesn't exist" do
      get "/feedbacks/#{2020}",
        params: {company_token: @company.token}
      expect(response.status).to eq(404)
    end
  end

  describe "GET /feedbacks/count" do
    it "responds with feedbacks correct count" do
      get "/feedbacks/count",
        params: {company_token: @company.token}
      expect(JSON.parse(response.body)).to \
        eq(@company.reload.feedbacks.count)
    end
  end

  describe "GET /feedbacks" do
    it "show a list of all company feedbacks" do
      get '/feedbacks', params: { company_token: @company.token }
      expect(response.status).to eq(200)
    end

    it "should have the company." do
      get '/feedbacks'
      expect(response.status).to eq(404)
    end

    it "list the correct feedbacks" do
      get '/feedbacks', params: { company_token: @company.token }
      expect(response.body).to eq(@company.feedbacks.to_json.to_s)
    end
  end
end
