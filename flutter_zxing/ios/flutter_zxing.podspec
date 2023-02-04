#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_zxing.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_zxing'
  s.version          = '0.0.1'
  s.summary          = 'ZXing C++ library'
  s.description      = <<-DESC
ZXing C++ library
                       DESC
  s.homepage         = 'https://github.com/githubguster'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = [
    'Classes/**/*',
    'native_code/**/*.{cpp,hpp,c,h}']
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.vdframework does not contain a i386 slice.
  s.libraries = 'c++'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'}
  s.xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
    'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) PERMISSION_CAMERA=1 PERMISSION_PHOTOS=1'
  }
  s.swift_version = '5.0'
  s.script_phases = [
    { :name => 'copy zxing-cpp',
      :script => 'sh '  + __dir__ + '/native_code.sh ',
      :execution_position => :before_compile }]
  s.module_map = 'flutter_zxing.modulemap'
end
