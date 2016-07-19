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
        # @params checker - The checker resource requesting to authorize
        #
        # For now the resource type of makers and checkers needs to be the same
        #
        def eligible_to_check(action, checker)
          (action.maker_id != checker.id) && (action.maker_type == checker.class.to_s)
        end

        # Cancel an action that had been previously initiated
        #
        def cancel
          @action = Action.find(params[:id])
          checker_id = params[:checker_id].to_i
          checker = @action.checker_type.constantize.find(checker_id)
          if @action
            @action.status = 'Cancelled'
            @action.checker = checker
            if @action.save
              flash[:notice] = "Action on #{@action.object_resource_type.titlecase} cancelled successfully."
              redirect_to action: :index and return
            else
              flash.now[:error] = @action.errors.full_messages
              redirect_to action: :index and return
            end
          end
        end

        # Perform the checker action for the maker checker actions
        # Dispatch to function to process the corresponding action (create, upated, delete)
        #
        def authorize
          @action = Action.find(params[:id])
          checker_id = params[:checker_id].to_i
          checker_type = params[:checker_type]
          raise 'Illegal Arguments' if (checker_id.blank? || checker_type.blank?)
          checker = checker_type.constantize.find(checker_id)
          if @action && @action.initiated? && checker
            if eligible_to_check(@action, checker)
              self.send(@action.action_type.gsub('action_', 'checker_'), @action, checker)
            else
              flash[:error] = 'You are not eligible to authorize this action'
              redirect_to action: :index and return
            end
          else
            flash[:error] = 'Illegal operation'
            redirect_to action: :index and return
          end
        end

        # Retrieve hash of saved parameters and instantiate a new object of type object_resource_class_name
        #
        # @param action - The action to authorize
        # @param checker - The checker resource requesting to authorize
        #
        def checker_create(action, checker)
          object_resource = action.object_resource_type.constantize.new(action.data.deep_symbolize_keys)
          if object_resource.save
            action.status = 'Authorized'
            action.checker = checker
            if action.save
              flash[:notice] = "#{action.object_resource_type.titlecase} authorized and created successfully."
              redirect_to action: :index and return
            else
              flash[:notice] = "#{action.object_resource_type.titlecase} created successfully. Action not updated"
              redirect_to action: :index and return
            end
          else
            flash[:error] = object_resource.errors.full_messages
            redirect_to action: :index and return
          end
        end

        # Retrieve hash of saved parameters and update the object of type object_resource_class_name
        #
        # @param action - The action to authorize
        # @param checker - The checker resource requesting to authorize
        #
        def checker_update(action, checker)
          begin
            object_resource = action.object_resource_type.constantize.find(action.object_resource_id)
            if object_resource.update_attributes(action.data.deep_symbolize_keys)
              action.status = 'Authorized'
              action.checker = checker
              if action.save
                flash[:notice] = "#{action.object_resource_type.titlecase} authorized and updated successfully."
                redirect_to action: :index and return
              else
                flash[:notice] = "#{action.object_resource_type.titlecase} updated successfully. Action not updated"
                redirect_to action: :index and return
              end
            else
              flash[:error] = object_resource.errors.full_messages
              redirect_to action: :index and return
            end
          rescue ActiveRecord::RecordNotFound
            flash[:error] = 'Record not found'
            redirect_to action: :index and return
          end
        end

        # Retrieve a delete action and call destroy on it
        #
        # @param action - The action to authorize
        # @param checker - The checker resource requesting to authorize
        #
        def checker_delete(action, checker)
          begin
            object_resource = action.object_resource_type.constantize.find(action.object_resource_id)
            if object_resource.destroy
              action.status = 'Authorized'
              action.checker = checker
              if action.save
                flash[:notice] = "#{action.object_resource_type.titlecase} authorized and deleted successfully."
                redirect_to action: :index and return
              else
                flash[:notice] = "#{action.object_resource_type.titlecase} deleted successfully. Action not updated"
                redirect_to action: :index and return
              end
            else
              flash[:error] = object_resource.errors.full_messages
              redirect_to action: :index and return
            end
          rescue ActiveRecord::RecordNotFound
            flash[:error] = 'Record not found'
            redirect_to action: :index and return
          end
        end
      end
    end
  end
end