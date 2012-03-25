class ApiController < ApplicationController
  # API Keys
  HUNCH_APP_ID       = ENV['HUNCH_APP_ID']
  HUNCH_APP_SECRET   = ENV['HUNCH_APP_SECRET']

  def auth
    unless params[:auth_token_key].nil?
      auth_token = get_auth_token(params[:auth_token_key])
      puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
      puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
      puts auth_token
      puts "***********************************"
      puts "***********************************"
      @user = current_user
      @user.set_token(auth_token)
      puts @user.auth_token
      redirect_to @user
    end
  end

  private

  def get_auth_token( auth_token_key )
    url = "http://api.hunch.com/api/v1/get-auth-token/?app_id=#{HUNCH_APP_ID}&auth_token_key=#{auth_token_key}"
    auth_sig = get_auth_sig(url, HUNCH_APP_SECRET)
    response = RestClient.get "#{url}&auth_sig=#{auth_sig}"
    result = JSON.parse(response)
    result["auth_token"]
  end

  def enc(string)
    return string.gsub(/%20/,'+').gsub(/[+\/@]/,'+' => '%2B', '/' => '%2F', '@' => '%4O')
  end

  def get_auth_sig(url, app_secret)
    params = {}
    URI.parse(url).query.split('&').each do |part|
      if name = part.split('=')[0] and val = part.split('=')[1]
        params[name] = val
      else
        params[name] = ''
      end
    end

    canonical = ''
    params.sort.each do |key,val|
      canonical += key + '=' + enc(val.encode('utf-8')) + '&'
    end

    #this removes the trailing &
    canonical = canonical[0,canonical.size-1]

    string_to_sign = enc(canonical) + app_secret
    return Digest::SHA1.hexdigest(string_to_sign)
  end

end
