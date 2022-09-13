class V1::FriendsController < ApplicationController
  before_action :authenticate_user!

  def show
    friends = current_user.applicants.joins(:friends).select('users.*, friends.accept')
    pending_friends = current_user.friends.joins(:applicants).select('users.*, friends.accept').uniq
    render json: { status: 'SUCCESS', data: [friends, pending_friends] }
  end

  def destroy
    current_user.del_friend(current_user.id, params[:friend_id])
    render json: { status: 'SUCCESS', data: 'フレンド解除に成功しました', color: 'green' }
  end

  def apply
    if current_user.friend?(params[:friend_id])
      current_user.approval_pending(current_user.id, params[:friend_id])
      render json: { status: 'SUCCESS', data: 'フレンド申請に成功しました', color: 'green' }
    else
      render json: { status: 'ERROR', data: 'すでにフレンド登録されています', color: 'red' }
    end
  end

  def approval
    friend = User.find(params[:friend_id])
    if current_user.accept?(params[:friend_id])
      render json: { status: 'ERROR', data: '承認に失敗しました', color: 'red' }
    else
      current_user.accept!(current_user.id, friend)
      render json: { status: 'SUCCESS', data: '承認に成功しました', color: 'green' }
    end
  end
end
