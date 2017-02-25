module UsersHelper
  def change_user_status(user)
    if current_user_admin
      if user.blocked
        status = 'activate'
      else
        status = 'freeze'
      end

      change_status = link_to(status, url_for([:toggle_freeze, user]), method: :post, class:"btn btn-warning")
      raw("#{change_status}")

    end
  end

end
