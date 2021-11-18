class V1::MessagesController < ApplicationController
	before_action :find_message, except: [:index, :create]
	def index
		@room = Room.find(params[:room_id])
		@messages = @room.messages
		render json: { status: 'SUCCESS', data: @messages }
	end

	def create
		@user = User.find(params[:user_id])
		@message = @user.messages.create(message_params)
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
    params.require(:message).permit(:content)
  end

	def find_message
    @message = Message.find(params[:id])
  end
end
