class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def update
    @user = User.find(params[:id])
    tag_list = params[:tags].split(',')
    @user.tag_save(tag_list)
    if @user.update(account_update_params)
      icon = @user.icon_url
      @user.update(icon_path: icon)
      render json: { status: 'SUCCESS', data: @user }
    else
      render json: { status: 'ERROR', data: @user }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: { status: 'SUCCESS' }
  end

  private

  def account_update_params
    params.permit(:address, :myinfo)
  end

  def render_create_success
    icon = @resource.icon_url
    @resource.update(icon_path: icon)
    render json: {
      status: 'success',
      data: resource_data,
      icon_path: icon
    }
  end
end
