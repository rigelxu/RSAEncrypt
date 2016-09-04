Pod::Spec.new do |s|
  s.name     = 'RSAEncrypt'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'RSAEncrypt是简单的RSA加密库。使用字符串进行加密.'
  s.description  = 'RSAEncrypt是简单的RSA加密库。使用字符串进行加密，包含使用 openssl 生成密钥对步骤。RSAEncrypt使用公钥文件 base64 字符串进行加密，避免了使用Security Framework API添加伪造证书字符串加密方式，可能会导致加密永久失败的问题（此问题重装应用才可解决）。'
  s.homepage = 'https://github.com/rigelxu/RSAEncrypt'
  s.author   = { 'Rigel' => 'mrxurj@gmail.com' }
  s.source   = { :git => 'https://github.com/rigelxu/RSAEncrypt.git', :tag => s.version.to_s }
  s.source_files = 'RSAEncrypt/*.{h,m}'
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.frameworks = 'Foundation', 'Security'
  s.requires_arc = true
end