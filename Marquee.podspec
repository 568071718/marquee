

Pod::Spec.new do |spec|
  spec.name         = 'Marquee'
  spec.summary      = 'Marquee'
  spec.version      = '0.0.1'
  
  spec.swift_version= '5.8'
  spec.ios.deployment_target  = '11.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/568071718/marquee'
  spec.authors      = { 'o.o.c.' => '568071718@qq.com' }
  spec.source       = { :git => 'https://github.com/568071718/marquee.git', :tag => "v#{spec.version}" }
  
  spec.source_files = 'Sources/**/*.{h,m,swift}'
  
end


