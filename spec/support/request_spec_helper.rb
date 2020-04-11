module RequestSpecHelper

  def get_auth_headers(user)
    response = login(user)
    get_auth_params_from_login_response_headers(response, true)
  end

  def login(user)
    post api_v1_user_session_path, params:  { email: user.email, password: user.password }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    response
  end

  def get_auth_params_from_login_response_headers(response, is_valid)


    if is_valid
      client = response.headers['client']
      token = response.headers['access-token']
    else
      client = 'rubbish'
      token = '123'
    end

    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
        'access-token' => token,
        'client' => client,
        'uid' => uid,
        'expiry' => expiry,
        'token-type' => token_type
    }
    auth_params
  end

end
