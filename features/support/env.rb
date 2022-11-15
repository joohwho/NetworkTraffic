require "capybara"
require "capybara/cucumber"
require "selenium-webdriver"
require 'capybara/poltergeist'
require "site_prism"
require "report_builder"
require "rspec"
require 'discordrb/webhooks'
require "colorize"
require 'pry'

require_relative "../support/module/DiscordModule.rb"

case ENV["BROWSER"]
when "chrome"
  @driver = :selenium_chrome
when "poltergeist"
  driver = Capybara::Poltergeist::Driver.new({})
  server = Capybara::Poltergeist::Server.new(nil, 30)
  client = Capybara::Poltergeist::Client.start(server,
      :path => driver.options[:phantomjs],
      :window_size => driver.options[:window_size],
      :phantomjs_options => driver.phantomjs_options
  )
  browser = Capybara::Poltergeist::Browser.new(server, client, nil)
  @driver = :poltergeist
when "headless"
  Capybara.register_driver :selenium_chrome_headless do |app|
    chrome_options = Selenium::WebDriver::Chrome::Options.new.tap do |options|
      options.add_argument "--headless"
      options.add_argument "--disable-gpu"
      options.add_argument "--no-sandbox"
      options.add_argument "--window-size=1920,1080"
      options.add_argument "--disable-site-isolation-trials"
    end
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
  end
  @driver = :selenium_chrome_headless
else
  puts "Invalid browser!"
end

Selenium::WebDriver::Chrome::Service.driver_path = "C:\\ProjetosAutomacao\\Ruby\\chromedriver\\chromedriver.exe"

Capybara.configure do |c|
  c.default_driver = @driver
  begin
    Capybara.page.driver.browser.manage.window.maximize
  rescue NoMethodError => e
    nil
  end
  c.default_max_wait_time = 10
  c.app_host = "https://www.google.com"
end

RSpec.configure do |config|
  include Discord

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
