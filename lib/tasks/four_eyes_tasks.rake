# desc "Explaining what the task does"
# task :four_eyes do
#   # Task goes here
# end
namespace :four_eyes_tasks do
  desc 'Upgrade from v0.x to v1.0'
  task upgrade_to_version_one: :environment do
    FourEyes::Action.find_each do |a|
      a.checker_type = a.maker_type
      a.save!
    end
  end
end

