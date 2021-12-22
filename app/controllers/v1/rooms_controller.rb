class V1::RoomsController < ApplicationController
  before_action :find_room, except: [:index, :new, :create, :search]
  def index
    @rooms = Room.all
    @favorite_rooms = Room.joins(:room_users).group(:room_id).order('count(user_id) desc')
    render json: { status: 'Success', data: [@rooms, @favorite_rooms] }
  end

  def new
    @users = User.all
    render json: { status: 'Success', data: @users }
  end

  def show
    @users = @room.users
    @messages = @room.messages
    render json: { status: 'Success', data: [@room, @users, @messages] }
  end

  def create
    @room = Room.new(room_params)
    users_list = params[:user_ids].split(',')
    @users = User.where(id: users_list)
    @room['image_path'] = @room.image_url
    if @room.save
      @room.join_user(@users)
      render json: { status: 'SUCCESS', data: @room }
    else
      render json: { status: 'ERROR', data: @room.errors }
    end
  end

  def update
    if @room.update(room_params)
      image_path = @room.image_url
      @room.update_attribute(:image_path, image_path)
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

  def search
    if params[:data].empty?
      @rooms = Room.where(private: 0)
    else
      search_value = params[:data].split(/[[:blank:]]+/)
      @rooms = []
      search_value.each do |src|
        rooms_data = Room.where(private: 0).where('name LIKE ? OR description LIKE ? OR genre LIKE ?', "%#{src}%", "%#{src}%",
                                                  "%#{src}%")
        @rooms += rooms_data
      end
      @rooms.uniq!
    end
    render json: { status: 'SUCCESS', data: @rooms }
  end

  private

  def room_params
    params.require(:room).permit(:name, :genre, :description, :image, :private, :leader)
  end

  def find_room
    @room = Room.find(params[:id])
  end
end
