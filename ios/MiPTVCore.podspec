Pod::Spec.new do |s|
  s.name         = 'MiPTVCore'
  s.version      = '0.1.0'
  s.summary      = 'React Native bridge for the MiPTVCore Rust library'
  s.homepage     = 'https://github.com/your-org/miptv'
  s.license      = { :type => 'MIT' }
  s.author       = 'MiPTV Team'
  s.platform     = :ios, '15.1'

  s.source       = { :path => '.' }

  # Bridge files + UniFFI-generated Swift bindings
  s.source_files = [
    'NativeMiPTVCore.mm',
    'NativeMiPTVCore.swift',
    'generated/ffi_uniffi.swift',
  ]

  # Pre-built xcframework (Rust static lib + FFI headers)
  s.vendored_frameworks = 'MiPTVCore.xcframework'

  s.dependency 'React-Core'
end
