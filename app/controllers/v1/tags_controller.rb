class V1::TagsController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])
    render json: { status: 'SUCCESS', data: user.tags }
  end
end
