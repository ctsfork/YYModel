Pod::Spec.new do |s|
  s.name         = 'YYModel'
  s.summary      = 'High performance model framework for iOS/OSX.'
  s.version      = '1.2.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'ibireme' => 'ibireme@gmail.com' }
  s.social_media_url = 'http://blog.ibireme.com'
  s.homepage     = 'https://github.com/ctsfork/YYModel'


  s.source       = { :git => 'https://github.com/ctsfork/YYModel.git', :tag => "#{s.version}" }
  
  
  s.source_files = 'YYModel/*.{h,m}'
  s.public_header_files = 'YYModel/*.{h}'

  ## 隐私清单
  s.resource_bundles = {'YYModel' => ['YYModel/PrivacyInfo.xcprivacy']}
  
  s.frameworks = 'Foundation', 'CoreFoundation'


  s.ios.deployment_target = '11.0' # minimum SDK with autolayout
  s.osx.deployment_target = '10.13' # minimum SDK with autolayout
  s.tvos.deployment_target = '11.0' # minimum SDK with autolayout
  s.watchos.deployment_target = '4.0' # minimum SDK with autolayout
  s.requires_arc = true

end
