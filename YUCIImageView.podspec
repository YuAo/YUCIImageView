Pod::Spec.new do |s|
  s.name         = 'YUCIImageView'
  s.version      = '0.4'
  s.author       = { 'YuAo' => 'me@imyuao.com' }
  s.homepage     = 'https://github.com/YuAo/YUCIImageView'
  s.summary      = 'An image view for rendering CIImage with Metal/OpenGL/CoreGraphics.'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = {:git => 'https://github.com/YuAo/YUCIImageView.git', :tag => '0.4'}
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'
  s.source_files = 'Sources/**/*.{h,m}'
end
