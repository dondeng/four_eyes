# desc "Explaining what the task does"
# task :four_eyes do
#   # Task goes here
# end
namespace :for_eyes_tasks do
  desc 'Upgrade from v0.x to v1.0'
  task :upgrade_to_version_one do
    FourEyes::Action.find_each do |a|
      a.checker_type = a.resource_class_name
      a.save!
    end
  end
end

