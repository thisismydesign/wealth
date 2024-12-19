# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization

  def active_admin_access_denied(exception)
    Rails.logger.warn(build_access_denied_message(exception))

    flash[:error] = exception.message
    redirect_to root_path
  end

  private

  def build_access_denied_message(exception)
    # rubocop:disable Layout/LineLength
    subject_id = exception.subject.is_a?(Class) ? '(Class)' : exception.subject&.id
    "Access denied on #{exception.action} #{exception.subject.class}##{subject_id} for User##{exception.user.id} from #{controller_path}/#{action_name}"
    # rubocop:enable Layout/LineLength
  end
end
