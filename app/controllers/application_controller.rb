class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :current_user

  private

  def current_user
    # sessionにuser_idがなければリターン
    return unless session[:user_id]
    # あれば@carrent_userに格納
    @current_user = User.find_by(id: session[:user_id])
  end
end
