class Api::FeedbacksController < ApplicationController
  before_action :set_company
  before_action :set_feedback, only: :show

  # GET /feedbacks
  def index
    @feedbacks = Feedback.search(params[:company_token]).records
    render json: @feedbacks
  end

  # POST /feedbacks
  def create
    @feedback = @company.feedbacks.new(feedback_params)
    if @feedback.save
      render json: { number: @feedback.number }, status: :created
    else
      render json: { errors: @feedback.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # GET /feedbacks/:number
  def show
    render json: @feedback
  end

  # GET /feedbacks/count
  # We may not need to use dalli and memcached here as we used counter_cache
  # that is already just a column in the @company.
  # we may need it if we get the feedbacks count by @company.feedbacks.count
  # that make another query to do so.
  def count
    @count = @company.fbs_count
    render json: @count
  end

  def as_indexed_json(options={})
    as_json(include: :state)
  end

  private

  def set_company
    @company = Company.find_by token: params[:company_token]
    render json: { msg: 'not fount' },
           status: :not_found unless @company
  end

  def set_feedback
    @feedback = @company.feedbacks.find_by number: params[:number]
    render json: { msg: 'not fount' },
           status: :not_found unless @feedback
  end

  def feedback_params
    params.require(:feedback)
          .permit(:priority,
                  :content,
                  state_attributes: [:os, :device, :memory, :storage])
  end
end
