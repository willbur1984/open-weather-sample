using_bundler = defined? Bundler

unless using_bundler
    puts "\nPlease re-run using:".red
    puts "bundle exec pod install\n\n"
end

install! 'cocoapods', :warn_for_unused_master_specs_repo => false
inhibit_all_warnings!
use_frameworks!

abstract_target 'open-weather-shared' do
    platform :ios, '15.0'

    pod 'CombineCocoa', '~> 0.4'
    pod 'CombineExt', '~> 1.0'
    pod 'Ditko', '~> 6.0'
    pod 'Feige', '~> 2.0'
    pod 'Moya/Combine', '~> 15.0'
    pod 'Kingfisher', '~> 7.0'
    pod 'Romita', '~> 2.0'
    pod 'Stanley', '~> 3.0'
    pod 'SwiftyJSON', '~> 5.0'

    target 'open-weather' do
    end

    abstract_target 'open-weather-tests-shared' do
        pod 'Nimble', '~> 10.0'
        pod 'Quick', '~> 5.0'

        target 'open-weatherTests' do
        end

        target 'open-weatherUITests' do
        end
    end
end

project 'open-weather'
workspace 'open-weather'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # fixes the iOS 8.0 deployment target warning for certain libraries
            config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'

            # disables code signing for all libraries
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
            # disables bitcode for all libraries
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end