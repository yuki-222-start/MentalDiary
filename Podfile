# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'MentalDiary' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MentalDiary
  pod 'FSCalendar'
  pod 'CalculateCalendarLogic'
  pod 'Firebase/Firestore'
  pod 'Firebase'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Charts'
  pod 'lottie-ios'

end

post_install do |installer|
  installer.pods_project.targets.each do |t|
   t.build_configurations.each do |config|

    # to make @IBDesignable work with IB
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
    config.build_settings['CONFIGURATION_BUILD_DIR'] ='$PODS_CONFIGURATION_BUILD_DIR'
   end
 end
end