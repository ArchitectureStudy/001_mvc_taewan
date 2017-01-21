# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'TaewanArchitectureStudy' do
	use_frameworks!
    
    pod 'SwiftyJSON', '~> 3.1'
#    pod 'RxSwift', '~> 3.0'
#    pod 'RxCocoa', '~> 3.0'
    
	pod 'Alamofire', '~> 4.2'
    pod 'AlamofireImage', '~> 3.1'
	pod 'NibDesignable', '~> 3.0'
	pod 'Then'
    
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
