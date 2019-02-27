# vim: set ft=ruby :

platform :ios, '11.0'

target 'nWorkout' do
  use_frameworks!

  target 'SnapshotTarget' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  pod 'CustomIOSAlertView' 
  pod 'DZNEmptyDataSet' 

  # pod 'ChartView', :git => 'https://github.com/lanza/ChartView', :branch => 'master'
  # pod 'CoordinatorKit', :git => 'https://github.com/lanza/CoordinatorKit'
  # pod 'Reuse', :git=> 'https://github.com/lanza/Reuse'

  pod 'ChartView', :path => '~/Projects/ChartView'
  pod 'CoordinatorKit', :path => '~/Projects/CoordinatorKit'
  pod 'Reuse', :path => '~/Projects/Reuse'

  pod 'Charts'
  pod 'CarbonKit'

  pod 'BonMot'
  pod 'Eureka'

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
