class V1::TagsController < ApplicationController
  def show
    user = User.find(params[:id])
    render json: { status: 'SUCCESS', data: user.tags }
  end
end
