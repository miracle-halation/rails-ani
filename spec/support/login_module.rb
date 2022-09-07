module LoginModule
  def login(user)
    test_params = { email: user.email, password: user.password }
    post user_session_path, params: test_params
    headers = response.headers
    { 'uid': headers['uid'], 'access-token': headers['access-token'], 'client': headers['client'] }
  end
end
