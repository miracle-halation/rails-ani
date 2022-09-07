class V1::TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { status: 'SUCCESS', data: current_user.tags }
  end
end
