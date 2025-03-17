module ArgosTracker
  class Engine < ::Rails::Engine
    isolate_namespace ArgosTracker

    initializer 'argos_tracker', before: :load_config_initializers do |app|
      Rails.application.routes.append do
        mount ArgosTracker::Engine, at: '/argos_tracker', as: 'argos_tracker'
      end

      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          Rails.application.config.paths['db/migrate'] << expanded_path
        end
      end
    end
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
