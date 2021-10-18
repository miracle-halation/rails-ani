class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
	def update
		@user = User.find(params[:id])
		tag_list = params[:tags].split(',')
		@user.tag_save(tag_list)
		if @user.update(account_update_params)
			render json: { status: 'SUCCESS', data: @user }
		else
			render json: { status: 'ERROR', data: @user }
		end
	end

	private

	def account_update_params
		params.permit(:address, :myinfo)
	end
end
