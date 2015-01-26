module FourEyes

  # This module is automatically included into all controllers that will be implementing the
  # Maker-Checker functionality
  #
  module ControllerAdditions
    module ClassMethods

      # Sets up a before filter which adds maker checker functionality to the controller
      #
      # @example
      #
      #   class StudentsController < ApplicationController
      #     add_maker_checker_to_resource
      #   end
      #
      def add_maker_checker_to_resource(*args)

        # Add maker functions
        four_eyes_resource_class.add_maker_create_function(self, :maker_create, *args)
        four_eyes_resource_class.add_maker_update_function(self, :maker_update, *args)
      end


      def four_eyes_resource_class
        if ancestors.map(&:to_s).include? "InheritedResources::Actions"
          InheritedResource
        else
          ControllerResource
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include FourEyes::ControllerAdditions
  end
end