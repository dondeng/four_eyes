module FourEyes
  class Action < ActiveRecord::Base
    validates :action_type, :maker_resource_id, :status, presence: true
    belongs_to :maker, polymorphic: true
    belongs_to :checker, polymorphic: true
    belongs_to :assignable, polymorphic: true
    belongs_to :object_resource, polymorphic: true

    def self.between_times(start_time, end_time)
      Action.where('created_at >= ? AND created_at < ?', start_time, end_time)
    end

    def initiated?
      self.status == 'Initiated'
    end

    def cancelled?
      self.status == 'Cancelled'
    end

    def authorized?
      self.status == 'Authorized'
    end
  end
end