# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
if Gem.loaded_specs.has_key?("rubocop-rspec")
    require "rubocop/rake_task"
end

Rails.application.load_tasks
RuboCop::RakeTask.new

task default: %i[spec brakeman rubocop]
