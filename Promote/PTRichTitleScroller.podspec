
Pod::Spec.new do |s|

  s.name         = 'PTRichTitleScroller'
  s.version      = '0.0.2'
  s.summary      = 'ios  跑马灯  for iOS 8 and up'
  s.description      = <<-DESC
        ios 跑马灯， 实现可无限循环滚动、分段式、可点击，欢迎使用！
                        DESC

  s.homepage     = 'https://github.com/zxpLearnios/Promote'
  s.license          = 'MIT'
  s.author       = { 'zjn' => 'zxp1991tqd@163.com' }
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/zxpLearnios/Promote.git', :tag => s.version.to_s }

  # 所有需要用到的文件	
  s.source_files  = 'Promote/*'
  s.swift_version  = '4.0'
  #s.dependency 'Cartography', '~>3.0.1'

end
