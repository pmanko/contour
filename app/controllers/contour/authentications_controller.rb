class Contour::AuthenticationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def index
  end

  def passthru
    render file: "#{Rails.root}/public/404", formats: [:html], status: 404, layout: false
  end

  def failure
    redirect_to new_user_session_path, alert: params[:message].blank? ? nil : params[:message].humanize
  end

  def create
    omniauth = request.env["omniauth.auth"]
    if omniauth
      omniauth['uid'] = omniauth['info']['email'] if omniauth['provider'] == 'google_apps' and omniauth['info']
      authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      omniauth['info']['email'] = omniauth['extra']['raw_info']['email'] if omniauth['info'] and omniauth['info']['email'].blank? and omniauth['extra'] and omniauth['extra']['raw_info']
      if authentication
        logger.info "Existing authentication found."
        session["user_return_to"] = request.env["action_dispatch.request.unsigned_session_cookie"]["user_return_to"] if request.env and request.env["action_dispatch.request.unsigned_session_cookie"] and request.env["action_dispatch.request.unsigned_session_cookie"]["user_return_to"] and session["user_return_to"].blank?
        flash[:notice] = "Signed in successfully." if authentication.user.active_for_authentication?
        sign_in_and_redirect(:user, authentication.user)
      elsif current_user
        logger.info "Logged in user found, creating associated authentication."
        current_user.authentications.create!( provider: omniauth['provider'], uid: omniauth['uid'] )
        redirect_to authentications_path, notice: "Authentication successful."
      else
        logger.info "Creating new user with new authentication."
        user = User.new(params[:user])
        user.apply_omniauth(omniauth)
        user.password = Devise.friendly_token[0,20] if user.password.blank?
        if user.save
          session["user_return_to"] = request.env["action_dispatch.request.unsigned_session_cookie"]["user_return_to"] if request.env and request.env["action_dispatch.request.unsigned_session_cookie"] and request.env["action_dispatch.request.unsigned_session_cookie"]["user_return_to"] and session["user_return_to"].blank?
          flash[:notice] = "Signed in successfully." if user.active_for_authentication?
          sign_in_and_redirect(:user, user)
        else
          session[:omniauth] = omniauth.except('extra')
          redirect_to new_user_registration_path
        end
      end
    else
      redirect_to authentications_path, alert: 'Authentication not successful.'
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    respond_to do |format|
      format.html { redirect_to authentications_path, notice: 'Successfully removed authentication.' }
      format.js
    end
  end
end
