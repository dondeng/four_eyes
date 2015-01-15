module FourEyes
  class ControllerResource

    # Define the dynamic maker_create function
    # This handles the storing of the action and it's meta data to the four_eyes_actions
    # table with the status of 'Initiated'
    #
    def self.add_maker_create_function(controller_class, method, *args)
      options = args.extract_options!
      resource_id = args[0]
      data = args[1]

      controller_class.send :define_method, method do |args|
        "#{method} #{args}"
        action = Action.new(maker_resource_id: resource_id,
                            action_type: 'action_create',
                            status: 'Initiated',
                            data: data)
        if action.save

        else

        end
      end

    end

    def self.add_maker_update_function(controller_class, method, *args)
      options = args.extract_options!
      resource_name = args.first

      controller_class.send :define_method, method do |args|

        "#{method} #{args}"
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