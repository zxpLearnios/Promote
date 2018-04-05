
Pod::Spec.new do |s|

  s.name         = 'PTTitleScroller'
  s.module_name  = 'TitleScroller'
  s.version      = '0.0.1'
  s.summary      = 'ios  跑马灯， 适配各种情况 for iOS 8 and up'

  s.homepage     = 'https://github.com/zxpLearnios/Promote'
  s.license          = 'MIT'
  s.author       = { 'zjn' => 'zxp1991tqd@163.com' }
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/zxpLearnios/Promote.git', :tag => s.version.to_s }

  s.source_files  = ['TitleScroller/*.swift', 'TitleScroller/PTTitleScroller.h'] 
  s.public_header_files = ['TitleScroller/PTTitleScroller.h']


 
end
