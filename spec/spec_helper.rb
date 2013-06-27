require 'rubygems'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

def setup
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'database_cleaner'

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  #Capybara.javascript_driver = :webkit

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    # config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end
    config.after(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.render_views

    config.after(:all) do
      #Get rid of carrierwave uploads
      if Rails.env.test? || Rails.env.cucumber?
        FileUtils.rm_rf(Dir["#{Rails.root}/public/test/[^.]*"])
      end
    end
  end

end

if ENV['DRB']
  require 'spork'
  Spork.prefork do
    setup
  end
  Spork.each_run do
    ActionDispatch::Reloader.cleanup!
    ActionDispatch::Reloader.prepare!
    # Removes spork errors, when you change routes
    Rails.application.reload_routes!
    # removes my spork warning of namespace class collisions(Managers primarily)
    Dir[File.expand_path('app/controllers/admin/*.rb')].each { |file| require file }
  end
else
  setup
end