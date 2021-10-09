class V1::RoomsController < ApplicationController
	def index
		rooms = Room.all
		render json: {status: 'Success', data: rooms}
	end

	def show
		room = Room.find(params[:id])
		users = room.users
		render json: {status: 'Success', data: [room, users]}
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
		room = Room.find(params[:id])
		if room.update(room_params)
			render json: { status: 'SUCCESS', data: room }
		else
			render json: { status: 'ERROR', data: room.errors }
		end
	end

	def destroy
	end

	private

	def room_params
		params.require(:room).permit(:name, :description, :image, :private, :leader)
	end
end