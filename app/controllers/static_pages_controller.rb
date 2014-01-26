class StaticPagesController < ApplicationController
  before_action :delete_group_id

  def home
  	if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  private
    def delete_group_id
      session[:group_id] = nil
    end

end
