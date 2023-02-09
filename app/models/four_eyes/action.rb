module FourEyes
  class Action < ActiveRecord::Base
    validates :action_type, :status, presence: true

    belongs_to :maker, polymorphic: true
    belongs_to :checker, polymorphic: true, optional: true
    belongs_to :assignable, polymorphic: true, optional: true
    belongs_to :object_resource, polymorphic: true, optional: true

    has_many :attachments, class_name: "FourEyes::Attachment", foreign_key: "four_eyes_action_id"

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
