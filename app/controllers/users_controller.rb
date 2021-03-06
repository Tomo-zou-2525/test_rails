class UsersController < ApplicationController
  def new
    @user = User.new(flash[:user])
  end

  def create
    user = User.new(set_user)
    if user.save
      # セッション変数に任意の値を設定すると、ページ遷移しても保持する
      session[:user_id] = user.id
      redirect_to mypage_path
    else
      redirect_to :back, flash: {
        user: user,
        error_messages: user.errors.full_messages
      }
    end
  end

  def me
  end

  private
  def set_user
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
