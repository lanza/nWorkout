# vim: set ft=ruby :

target 'nWorkout' do
  use_frameworks!

  target 'SnapshotTarget' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  pod 'CustomIOSAlertView'

  pod 'DZNEmptyDataSet'

  pod 'Hero', '0.3.6'


  ##pod 'RxKeyboard'
  ##pod 'RxGesture'
  
  # if `whoami`[0...-1] == 'lanza'
  #   puts 'true'
  #   pod 'CoordinatorKit', :path => '~/Documents/CoordinatorKit', :branch => 'master'
  #   pod 'ChartView', :path => '~/Documents/ChartView', :branch => 'master'
  #   pod 'Reuse', :path => '~/Documents/Reuse', :branch => 'master'
  # else 
    # puts 'false'
    pod 'CoordinatorKit', :git => 'https://github.com/lanza/CoordinatorKit'
    pod 'ChartView', :git => 'https://github.com/lanza/ChartView'
    pod 'Reuse', :git=> 'https://github.com/lanza/Reuse'
  # end

  pod 'Charts', '3.0.2'
  pod 'CarbonKit', '2.1.9'

  pod 'BonMot', '4.1'
  pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka', :branch => 'feature/Xcode9-Swift3_2'

  pod 'RxSwift', '3.5.0'
  pod 'RxDataSources', '1.0.3'
  pod 'RealmSwift', '2.7.0'
  pod 'RxRealm', '0.6.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["SWIFT_VERSION"] = '3.0'
    end
  end
end
