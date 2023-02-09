module FourEyes
  class Attachment < ActiveRecord::Base
    validates :name, presence: true

    belongs_to :action, class_name: "FourEyes::Action", foreign_key: "four_eyes_action_id"

    has_many_attached :pages
  end
end
