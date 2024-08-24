# class ChangeFilterService
#   def self.call(start_date, end_date, field = nil)
#     query = Change.where(created_at: start_date..end_date)
#     query = query.where(field: field) if field.present?

#     # Fetch all changes within the date range, then group them manually by user_id and field
#     changes = query.order(:user_id, :field, created_at: :desc).to_a

#     # Group changes by user_id and field, and only keep the latest change for each group
#     latest_changes = changes.group_by { |change| [change.user_id, change.field] }
#                             .map { |_, group| group.first }

#     latest_changes
#   end
# end
module Changes
  class Filter
    def self.call(start_date, end_date, field = nil)
      query = Change.where(created_at: start_date..end_date)
      query = query.where(field: field) if field.present?

      changes = query.order(:user_id, :field, created_at: :desc).to_a

      latest_changes = changes.group_by { |change| [change.user_id, change.field] }
                              .map { |_, group| group.first }

      latest_changes
    rescue ArgumentError => e
      raise Changes::Errors::InvalidDateFormat, e.message
    rescue StandardError => e
      raise Changes::Errors::UnexpectedError, e.message
    end
  end
end
