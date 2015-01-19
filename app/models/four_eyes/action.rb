module FourEyes
  class Action < ActiveRecord::Base
    validates :action_type, :maker_resource_id, :status, presence: true

  end
end