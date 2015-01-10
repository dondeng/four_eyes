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

        # Add maker function
        four_eyes_resource.class.add_before

        # Add checker function

      end







      def cancan_resource_class
        if ancestors.map(&:to_s).include? "InheritedResources::Actions"
          InheritedResource
        else
          ControllerResource
        end
      end
    end

  end
end