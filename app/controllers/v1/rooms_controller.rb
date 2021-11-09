class V1::RoomsController < ApplicationController
  before_action :find_room, except: [:index, :create]
  def index
    @rooms = Room.all
    render json: { status: 'Success', data: @rooms }
  end

  def show
    @users = @room.users
    render json: { status: 'Success', data: [@room, @users] }
  end

  def create
    @room = Room.new(room_params)
    if room.save
      render json: { status: 'SUCCESS', data: @room }
    else
      render json: { status: 'ERROR', data: @room.errors }
    end
  end

  def update
    if @room.update(room_params)
      render json: { status: 'SUCCESS', data: @room }
    else
      render json: { status: 'ERROR', data: @room.errors }
    end
  end

  def destroy
    if @room.destroy
      render json: { status: 'SUCCESS' }
    else
      render json: { status: 'ERROR' }
    end
  end

  def join
    @user = User.find(params[:user_id])
    @room.join_user(@user)
    render json: { status: 'SUCCESS' }
  end

  def depart
    @user = User.find(params[:user_id])
    @room.depart_user(@user)
    render json: { status: 'SUCCESS' }
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :image, :private, :leader)
  end

  def find_room
    @room = Room.find(params[:id])
  end
end
