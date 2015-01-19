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
    unloadable

    # @example
    #   GET /actions
    #   GET /actions.xml
    #   GET /actions.json
    def index
      @actions = Action.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @actions }
        format.json  { render :json => @actions }
      end
    end

    # @example
    #   GET /action/1
    #   GET /action/1.xml
    #   GET /action/1.json
    def show
      @action = Action.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @action }
        format.json  { render :json => @action }
      end
    end
  end
end