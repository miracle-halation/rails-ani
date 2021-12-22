class V1::FriendsController < ApplicationController
  before_action :find_user, only: [:show, :destroy]
  before_action :current_user, only: [:apply, :approval]

  def show
    friends = @user.applicants.joins(:friends).select('users.*, friends.accept')
    pending_friends = @user.friends.joins(:applicants).select('users.*, friends.accept').uniq
    render json: { status: 'SUCCESS', data: [friends, pending_friends] }
  end

  def destroy
    @user.del_friend(@user.id, params[:friend_id])
    render json: { status: 'SUCCESS', data: 'フレンド解除に成功しました', color: 'green' }
  end

  def apply
    if @user.friend?(params[:friend_id])
      @user.approval_pending(@user.id, params[:friend_id])
      render json: { status: 'SUCCESS', data: 'フレンド申請に成功しました', color: 'green' }
    else
      render json: { status: 'ERROR', data: 'すでにフレンド登録されています', color: 'red' }
    end
  end

  def approval
    friend = User.find(params[:friend_id])
    if @user.accept?(params[:friend_id])
      render json: { status: 'ERROR', data: '承認に失敗しました', color: 'red' }
    else
      @user.accept!(@user.id, friend)
      render json: { status: 'SUCCESS', data: '承認に成功しました', color: 'green' }
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def current_user
    @user = User.find(params[:user_id])
  end
end
