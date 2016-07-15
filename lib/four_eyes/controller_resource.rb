module FourEyes
  class ControllerResource

    # Define the dynamic maker_create function
    # This handles the storing of the action and it's meta data to the four_eyes_actions
    # table with the status of 'Initiated'
    #
    def self.add_maker_create_function(controller_class, method, *args)
      options = args.extract_options!
      controller_class.send :define_method, method do |*args|
        "#{method} #{args}"
        maker = args[0]
        object_class_name = args[1]
        data = args[3]
        assignee = args[4]

        action = FourEyes::Action.new(maker: maker,
                                      action_type: 'action_create',
                                      object_resource_type: object_class_name,
                                      status: 'Initiated',
                                      data: data,
                                      assignable: assignee)
        if action.save!
          true
        else
          # TODO dondeng - Better to raise an exception here
          false
        end
      end
    end

    def self.add_maker_update_function(controller_class, method, *args)
      options = args.extract_options!
      controller_class.send :define_method, method do |*args|
        maker = args[0]
        object_resource = args[1]
        data = args[2]
        assignee = args[3]

        action = FourEyes::Action.new(maker: maker,
                                      action_type: 'action_update',
                                      object_resource: object_resource,
                                      status: 'Initiated',
                                      data: data,
                                      assignable: assignee)
        if action.save
          true
        else
          # TODO - dondeng - Better to raise an exception here
          false
        end
      end
    end

    def self.add_maker_delete_function(controller_class, method, *args)
      options = args.extract_options!
      controller_class.send  :define_method, method do |*args|
        maker = args[0]
        object_resource = args[1]
        data = args[2]
        assignee = args[3]
        action = FourEyes::Action.new(maker: maker,
                                      action_type: 'action_delete',
                                      object_resource: object_resource,
                                      status: 'Initiated',
                                      data: data,
                                      assignable: assignee)
        if action.save
          true
        else
          # TODO - dondeng - Better to raise an exception here
          false
        end
      end
    end

    def self.add_maker_generic_function(controller_class, method, *args)
      options = args.extract_options!
      controller_class.send  :define_method, method do |*args|
        maker = args[0]
        object_resource = args[1]
        action = args[2]
        data = args[3]

        action = FourEyes::Action.new(maker: maker,
                                      action_type: action,
                                      object_resource: object_resource,
                                      status: 'Initiated',
                                      data: data)
        if action.save
          true
        else
          # TODO - dondeng - Better to raise an exception here
          false
        end
      end
    end

    def initialize(controller, *args)
      @controller = controller
      @params = controller.params
      @options = args.extract_options!
      @name = args.first
    end
  end
end