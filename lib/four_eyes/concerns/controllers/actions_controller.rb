module FourEyes
  module Concerns
    module Controllers
      module Actions
        extend ActiveSupport::Concern

        #included do
        #end

        # @example
        #   GET /actions
        #   GET /actions.xml
        #   GET /actions.json
        def index
          @actions = Action.all

          respond_to do |format|
            format.html # index.html.erb
            format.xml { render :xml => @actions }
            format.json { render :json => @actions }
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
            format.xml { render :xml => @action }
            format.json { render :json => @action }
          end
        end
      end
    end
  end
end