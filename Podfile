# vim: set ft=ruby :

target 'nWorkout' do

  use_frameworks!

  pod 'CustomIOSAlertView'

  pod 'DZNEmptyDataSet'

  pod 'Hero'


  ##pod 'RxKeyboard'
  ##pod 'RxGesture'
  
  if `whoami`[0...-1] == 'lanza'
    puts 'true'
    pod 'CoordinatorKit', :path => '~/Documents/CoordinatorKit', :branch => 'master'
    pod 'ChartView', :path => '~/Documents/ChartView', :branch => 'master'
    pod 'Reuse', :path => '~/Documents/Reuse', :branch => 'master'
  else 
    puts 'false'
    pod 'CoordinatorKit', :git => 'https://github.com/nathanlanza/CoordinatorKit'
    pod 'ChartView', :git => 'https://github.com/nathanlanza/ChartView'
    pod 'Reuse', :git=> 'https://github.com/nathanlanza/Reuse'
  end

  pod 'Charts', :git => 'https://github.com/danielgindi/Charts', :branch => 'master'
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
