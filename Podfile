# vim: set ft=ruby :

platform :ios, '13.0'

target 'nWorkout' do
  use_frameworks!

  pod 'CustomIOSAlertView'

  if ENV['TRAVIS'] == 'TRAVIS' then
    pod 'ChartView', :git => 'https://github.com/nworkout/ChartView'
    pod 'CoordinatorKit', :git => 'https://github.com/nworkout/CoordinatorKit'
  else
    pod 'ChartView', :path => '~/Projects/nWorkout/ChartView'
    pod 'CoordinatorKit', :path => '~/Projects/nWorkout/CoordinatorKit'
  end

  pod 'Charts'
  pod 'CarbonKit'

  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'RealmSwift'
  pod 'RxRealm'

end

# post_install do |installer|
#   installer.pods_project.targets.each do |target|
#     target.build_configurations.each do |config|
#       config.build_settings["SWIFT_VERSION"] = '3.0'
#     end
#   end
# end
