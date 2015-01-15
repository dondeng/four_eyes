module FourEyes
  class Action < ActiveRecord::Base
    validates :action_type, :maker_resource_id, :data, :status, presence: true

  end
end