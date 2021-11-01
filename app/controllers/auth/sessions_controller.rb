class Auth::SessionsController < DeviseTokenAuth::SessionsController
  def render_create_success
    icon = @resource.icon_url
    render json: {
      data: resource_data(resource_json: @resource.token_validation_response),
      icon_path: icon
    }
  end
end
