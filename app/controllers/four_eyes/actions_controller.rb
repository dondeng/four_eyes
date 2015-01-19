module FourEyes
  # This controller provides restful route handling for Accounts.
  #
  # The controller supports ActiveResource, and provides for
  # HMTL, XML, and JSON presentation.
  #
  # == Security:
  # Only GET requests are supported. You should ensure that your application
  # controller enforces its own authentication and authorization, which this
  # controller will inherit.
  #
  # @author Dennis Ondeng
  class ActionsController < ApplicationController
    include FourEyes::Concerns::Controllers::Actions
  end
end