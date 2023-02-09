require 'four_eyes/version'
require 'four_eyes/controller_resource'
require 'four_eyes/controller_additions'
require 'four_eyes/inherited_resource'
require 'four_eyes/concerns/controllers/actions_controller'

module FourEyes
  class Engine < ::Rails::Engine
    isolate_namespace FourEyes
    config.autoload_paths += Dir["#{config.root}/lib"]
  end
end
