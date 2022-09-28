class V1::TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])
    @tags = user.tags
    render json: { status: 'SUCCESS', data: @tags }
  end
end
