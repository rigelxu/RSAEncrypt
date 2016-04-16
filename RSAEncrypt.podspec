Pod::Spec.new do |s|
  s.name     = 'RSAEncrypt'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'iOS 简单 RSA 加密方法。'
  s.description  = <<-DESC
      iOS 简单 RSA 加密方法，加密 key 使用字符串方式。使用系统库，包含如何创建钥匙对。
  s.homepage = 'https://github.com/rigelxu/RSAEncrypt'
  s.author   = { 'Rigel' => 'mrxurj@gmail.com' }
  s.source   = { :git => 'https://github.com/rigelxu/RSAEncrypt.git', :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = '*.{h,m}'
  s.frameworks = 'Foundation', 'Security'
  s.requires_arc = true
end