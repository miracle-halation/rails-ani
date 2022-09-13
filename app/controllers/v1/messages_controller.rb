class V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_message, except: [:create]
  before_action :find_user_icon, except: [:destroy]

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      render json: { status: 'SUCCESS', data: @message }
    else
      render json: { status: 'ERROR', data: @message.errors }
    end
  end

  def update
    if @message.update(message_params)
      render json: { status: 'SUCCESS', data: @message }
    else
      render json: { status: 'ERROR', data: @message.errors }
    end
  end

  def destroy
    if @message.destroy
      render json: { status: 'SUCCESS' }
    else
      render json: { status: 'ERROR' }
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :room_id).merge(icon_path: @icon_path)
  end

  def find_message
    @message = Message.find(params[:id])
  end

  def find_user_icon
    @icon_path = current_user.icon_url
  end
end
