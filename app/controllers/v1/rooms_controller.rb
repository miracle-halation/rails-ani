class V1::RoomsController < ApplicationController
	def index
		rooms = Room.all
		render json: {status: 'Success', data: rooms}
	end

	def show
	end

	def create
		room = Room.new(room_params)
		if room.save
			render json: { status: 'SUCCESS', data: room }
		else
			render json: { status: 'ERROR', data: room.errors }
		end
	end

	def update
	end

	def destroy
	end

	private

	def room_params
		params.require(:room).permit(:name, :description, :image, :private, :leader)
	end
end
