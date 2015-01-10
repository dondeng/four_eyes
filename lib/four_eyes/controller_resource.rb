module FourEyes
  class ControllerResource
    def self.add_maker_checker_functions(controller_class, method, *args)
      options = args.extract_options!
      resource_name = args.first

      controller_class.send :define_method, method do |args|
        "#{method} #{args}"
      end
    end
  end
end