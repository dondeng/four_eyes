module FourEyes
  class Action < ActiveRecord::Base
    validates :action_type, :status, presence: true

    belongs_to :maker, polymorphic: true
    belongs_to :checker, polymorphic: true, optional: true
    belongs_to :assignable, polymorphic: true, optional: true
    belongs_to :object_resource, polymorphic: true, optional: true

    def self.between_times(start_time, end_time)
      Action.where('created_at >= ? AND created_at < ?', start_time, end_time)
    end

    def initiated?
      status == 'Initiated'
    end

    def cancelled?
      status == 'Cancelled'
    end

    def authorized?
      status == 'Authorized'
    end
  end
end
