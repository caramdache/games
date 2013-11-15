$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Games'
  app.version = '0.3'
  app.identifier = 'com.gametestgame.games'
  app.frameworks += ['CoreData']
  app.device_family = [:iphone, :ipad]
  app.files += Dir.glob(File.join(app.project_dir, 'app/lib/**/*.rb')) |
               Dir.glob(File.join(app.project_dir, 'app/**/*.rb'))
  
  app.vendor_project('vendor/ISO-8601-parser', :static)

  app.seed_id = 'XXXX'

  app.entitlements['keychain-access-groups']                              = [%(#{app.seed_id}.#{app.identifier})]  # keys needed by applications which are sharing keychain data
  app.entitlements['com.apple.developer.ubiquity-kvstore-identifier']     =  %(#{app.seed_id}.#{app.identifier})   # unique id which points to the key-value store in iCloud
  app.entitlements['com.apple.developer.ubiquity-container-identifiers']  = [%(#{app.seed_id}.#{app.identifier})]  # directories in iCloud in which your application can read/write documents
end
