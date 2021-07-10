class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  if ENV["BASIC_AUTH_USERNAME"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_raven_context
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.json { head :forbidden, content_type: "text/html" }
      format.html { render plain: "403 Forbidden", status: :forbidden }
      format.js   { head :forbidden, content_type: "text/html" }
    end
  end

private

  def record_not_found
    render plain: "404 Not Found", status: :not_found
  end

  def set_raven_context
    Raven.extra_context(
      params: params.to_unsafe_h,
      url: request.url,
      environment: Rails.env,
      app_environment: ENV["VCAP_APPLICATION"],
    )

    return unless current_user

    Raven.user_context(
      id: current_user.id,
      name: current_user.name,
      email: current_user.email,
      organisation_id: current_user.primary_organisation.id,
      organisation: current_user.primary_organisation.name,
    )
  end
end
