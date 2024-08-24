class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from StandardError, with: :handle_standard_error

  private

  def handle_record_invalid(exception)
    render json: { error: exception.message }, status: :unprocessable_entity
  end

  def handle_parameter_missing(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def handle_standard_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end
end
