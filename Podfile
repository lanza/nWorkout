target 'nWorkout' do

  use_frameworks!

  pod 'CustomIOSAlertView', '~> 0.9.5'

  pod 'DZNEmptyDataSet'

  pod 'RxSwift', '3.0'
  pod 'RxCocoa', '3.0'
  pod 'RealmSwift'
  pod 'RxRealm'

  pod 'RxKeyboard'
  pod 'RxGesture'
  pod 'RxDataSources'
  
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

  pod 'Charts'
  pod 'CarbonKit'

  pod 'BonMot'
  pod 'Eureka', '~> 2.0.0-beta.1'

end
