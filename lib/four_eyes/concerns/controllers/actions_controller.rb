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

        # Perform a checker eligibility test.
        # At the most basic level, the actor doing the initiating cannot be the same person
        # doing the checking
        #
        # @params action - The action to be authorized
        # @params resource - The id of the actor requesting the authorization
        #
        def eligible_to_check(action, resource_id)
          action.maker_resource_id != resource_id
        end


        # Perform the checker action for the maker checker actions
        # Dispatch to function to process the corresponding action (create, upated, delete)
        #
        # @params id - The id of the action being authorized
        # @params checker_resource_id - The id of the actor performing the authorization
        #
        def authorize
          @action = Action.find(params[:id])
          checker_resource_id = params[:checker_resource_id].to_i
          if eligible_to_check(@action, checker_resource_id)
            if @action && @action.initiated? && checker_resource_id
              if @action.action_type == 'action_create'
                checker_create(@action, checker_resource_id)
              elsif @action.action_type == 'action_update'
                checker_update(@action, checker_resource_id)
              end
            end
          else
            flash[:notice] = "You are not eligible to authorize this action"
            redirect_to action: :index and return
          end
        end



        # Retrieve hash of saved parameters and instantiate a new object of type object_resource_class_name
        #
        # @params action - The action to authorize
        # @params resource_id - The id of the actor performing the authorization
        #
        def checker_create(action, resource_id)
          object_resource = action.object_resource_class_name.constantize.new(action.data.deep_symbolize_keys)
          if object_resource.save
            action.status = 'Authorized'
            action.checker_resource_id = resource_id
            if action.save
              flash[:notice] = "#{action.object_resource_class_name} authorized and created successfully."
              redirect_to action: :index and return
            else
              flash[:notice] = "#{action.object_resource_class_name} created successfully. Action not updated"
              redirect_to action: :index and return
            end
          else
            flash[:error] = object_resource.errors.full_messages
            redirect_to action: :index and return
          end
        end

        # Retrieve hash of saved parameters and update the object of type object_resource_class_name
        #
        # @params action - The action to authorize
        # @params resource_id - The id of the actor performing the authorization
        #
        def checker_update(action, resource_id)
          object_resource = action.object_resource_class_name.constantize.find(action.object_resource_id)
          if object_resource.update_attributes(action.data.deep_symbolize_keys)
            action.status = 'Authorized'
            action.checker_resource_id = resource_id
            if action.save
              flash[:notice] = "#{action.object_resource_class_name} authorized and updated successfully."
              redirect_to action: :index and return
            else
              flash[:notice] = "#{action.object_resource_class_name} updated successfully. Action not updated"
              redirect_to action: :index and return
            end
          else
            flash[:error] = object_resource.errors.full_messages
            redirect_to action: :index and return
          end
        end


        # Cancel an action that had been previously initiated
        #
        # @params action - The action that is to be cancelled
        # @params resource_id - The id of the actor performing the cancellation
        #
        def cancel
          @action = Action.find(params[:id])
          checker_resource_id = params[:checker_resource_id].to_i
          if @action
            @action.status = 'Cancelled'
            @action.checker_resource_id = checker_resource_id
            if @action.save
              flash[:notice] = "Action on #{@action.object_resource_class_name} cancelled successfully."
              redirect_to action: :index and return
            else
              flash.now[:error] = @action.errors.full_messages
              redirect_to action: :index and return
            end
          end
        end
      end
    end
  end
end