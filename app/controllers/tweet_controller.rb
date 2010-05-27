class TweetController < ApplicationController
  def new
    tmp = UserSession.find
    if tmp
      @user = tmp.user
    else
      redirect_to login_path
    end
  end

  def create
    user = UserSession.find.user
    Tweet.new(user, params[:tweets][:text]).save
    redirect_to '/tweet/new'
  end
end
