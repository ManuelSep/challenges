# class ChangeTrackerService
#   def self.call(user_id, old_hash, new_hash, parent_field = nil)
#     changes = []
#     all_keys = old_hash.keys | new_hash.keys

#     all_keys.each do |key|
#       full_field = parent_field ? "#{parent_field}.#{key}" : key.to_s
#       old_value = old_hash[key]
#       new_value = new_hash[key]

#       if old_value.is_a?(Hash) && new_value.is_a?(Hash)
#         changes.concat(self.call(user_id, old_value, new_value, full_field))
#       elsif old_value != new_value
#         Change.create!(
#           user_id: user_id,
#           field: full_field,
#           old_value: old_value,
#           new_value: new_value,
#           changed_at: Time.current
#         )
#       end
#     end

#     changes
#   end
# end
module Changes
  class Tracker
    def self.call(user_id, old_hash, new_hash, parent_field = nil)
      changes = []
      all_keys = old_hash.keys | new_hash.keys

      all_keys.each do |key|
        full_field = parent_field ? "#{parent_field}.#{key}" : key.to_s
        old_value = old_hash[key]
        new_value = new_hash[key]

        if old_value.is_a?(Hash) && new_value.is_a?(Hash)
          changes.concat(self.call(user_id, old_value, new_value, full_field))
        elsif old_value != new_value
          Change.create!(
            user_id: user_id,
            field: full_field,
            old_value: old_value,
            new_value: new_value,
            changed_at: Time.current
          )
        end
      end

      changes
    rescue ActiveRecord::RecordInvalid => e
      raise Changes::Errors::RecordInvalid, e.message
    rescue StandardError => e
      raise Changes::Errors::UnexpectedError, e.message
    end
  end
end
