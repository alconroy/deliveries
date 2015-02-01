RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::UploadHelpers, type: :feature
end
