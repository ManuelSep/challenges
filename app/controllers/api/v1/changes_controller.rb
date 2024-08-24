module Api
  module V1
    class ChangesController < ApplicationController
      def create
        user_id = change_params[:user_id].to_i
        unless user_id.positive?
          render json: { error: 'user_id must be a positive integer' }, status: :unprocessable_entity and return
        end

        old_data = change_params[:old] || {}
        new_data = change_params[:new] || {}

        if old_data.blank? && new_data.blank?
          render json: { error: 'Both old and new data cannot be empty' }, status: :bad_request
          return
        end

        begin
          Changes::Tracker.call(user_id, old_data, new_data)
          render json: { message: 'Changes tracked successfully' }, status: :created
        rescue Changes::Errors::RecordInvalid => e
          render json: { error: e.message }, status: :unprocessable_entity
        rescue Changes::Errors::UnexpectedError => e
          render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
        end
      end

      def index
        begin
          start_date = params[:start_date] ? DateTime.parse(params[:start_date]) : DateTime.new(0)
          end_date = params[:end_date] ? DateTime.parse(params[:end_date]) : DateTime.now
          field = params[:field]
        rescue ArgumentError
          render json: { error: 'Invalid date format' }, status: :bad_request and return
        end

        begin
          changes = Changes::Filter.call(start_date, end_date, field)
          render json: changes.map { |change| { field: change.field, old: change.old_value, new: change.new_value } }
        rescue Changes::Errors::InvalidDateFormat => e
          render json: { error: e.message }, status: :bad_request
        rescue Changes::Errors::UnexpectedError => e
          render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
        end
      end

      private

      def change_params
        params.permit(:user_id, old: {}, new: {})
      end
    end
  end
end
