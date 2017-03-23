# vim: set ft=ruby :

target 'nWorkout' do

  use_frameworks!

  pod 'CustomIOSAlertView'

  pod 'DZNEmptyDataSet'

  pod 'Hero'

  pod 'RxSwift', '~> 3'
  pod 'RxCocoa', '~> 3'
  pod 'RealmSwift', '~> 2'
  pod 'RxRealm'

  ##pod 'RxKeyboard'
  ##pod 'RxGesture'
  pod 'RxDataSources'
  
  if `whoami`[0...-1] == 'lanza'
    puts 'true'
    pod 'CoordinatorKit', :path => '~/Documents/CoordinatorKit', :branch => 'master'
    pod 'ChartView', :path => '~/Documents/ChartView', :branch => 'master', :version => '~> 0.0.1'
    pod 'Reuse', :path => '~/Documents/Reuse', :branch => 'master'
  else 
    puts 'false'
    pod 'CoordinatorKit', :git => 'https://github.com/nathanlanza/CoordinatorKit'
    pod 'ChartView', :git => 'https://github.com/nathanlanza/ChartView', '~> 0.0.2'
    pod 'Reuse', :git=> 'https://github.com/nathanlanza/Reuse'
  end

  pod 'Charts'
  pod 'CarbonKit'

  pod 'BonMot'
  pod 'Eureka', '~> 2.0.0-beta.1'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["SWIFT_VERSION"] = '3.0'
    end
  end
end
