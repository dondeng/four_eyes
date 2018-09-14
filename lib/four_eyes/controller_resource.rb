module FourEyes
  class ControllerResource

    def initialize(controller, *args)
      @controller = controller
      @params = controller.params
      @options = args.extract_options!
      @name = args.first
    end

    # Define the dynamic maker_create function
    # This handles the storing of the action and it's meta data to the four_eyes_actions
    # table with the status of 'Initiated'
    #
    def self.add_maker_create_function(controller_class, method, *args)
      # TODO: extract options and process
      options = args.extract_options!
      controller_class.send :define_method, method do |*args|
        maker = args[0]
        object_class_name = args[1]
        data = args[2]
        assignee = args[3].nil? ? nil : args[3]

        action = FourEyes::Action.new(maker: maker,
                                      action_type: 'action_create',
                                      object_resource_type: object_class_name,
                                      status: 'Initiated',
                                      data: data,
                                      assignable: assignee)

        raise FourEyes::Errors::UnprocessableAction, 'Failed to create action' unless action.save
        action
      end
    end

    def self.add_maker_update_function(controller_class, method, *args)
      #TODO - extract options and process
      options = args.extract_options!
      controller_class.send :define_method, method do |*args|
        maker = args[0]
        object_resource = args[1]
        before_data = args[2][:before_data]
        data = args[2][:data]
        assignee = args[3].nil? ? nil : args[3]

        if FourEyes::Action.exists?(object_resource_type: object_resource.class.to_s,
                                    object_resource_id: object_resource.id,
                                    status: 'Initialized')
          raise FourEyes::Errors::UnprocessableAction, 'Object has pending action'
        end
        action = FourEyes::Action.new(maker: maker,
                                      action_type: 'action_update',
                                      object_resource: object_resource,
                                      status: 'Initiated',
                                      data: data,
                                      before_data: before_data,
                                      assignable: assignee)
        raise FourEyes::Errors::UnprocessableAction, 'Failed to create action' unless action.save
        action
      end
    end

    def self.add_maker_delete_function(controller_class, method, *args)
      # TODO: extract options and process
      options = args.extract_options!
      controller_class.send :define_method, method do |*args|
        maker = args[0]
        object_resource = args[1]
        data = args[2]
        assignee = args[3].nil? ? nil : args[3]
        if FourEyes::Action.exists?(object_resource_type: object_resource.class.to_s,
                                    object_resource_id: object_resource.id,
                                    status: 'Initialized')
          raise FourEyes::Errors::UnprocessableAction, 'Object has pending action'
        end
        action = FourEyes::Action.new(maker: maker,
                                      action_type: 'action_delete',
                                      object_resource: object_resource,
                                      status: 'Initiated',
                                      data: data,
                                      assignable: assignee)
        raise FourEyes::Errors::UnprocessableAction, 'Failed to create action' unless action.save
        action
      end
    end

    def self.add_maker_generic_function(controller_class, method, *args)
      # TODO: extract options and process
      options = args.extract_options!
      controller_class.send  :define_method, method do |*args|
        maker = args[0]
        object_resource = args[1]
        action = args[2]
        data = args[3]
        assignee = args[4].nil? ? nil : args[4]
        if FourEyes::Action.exists?(object_resource_type: object_resource.class.to_s,
                                    object_resource_id: object_resource.id,
                                    status: 'Initialized')
          raise FourEyes::Errors::UnprocessableAction, 'Object has pending action'
        end
        action = FourEyes::Action.new(maker: maker,
                                      action_type: action,
                                      object_resource: object_resource,
                                      status: 'Initiated',
                                      data: data,
                                      assignable: assignee)
        raise FourEyes::Errors::UnprocessableAction, 'Failed to create action' unless action.save
        action
      end
    end
  end
end