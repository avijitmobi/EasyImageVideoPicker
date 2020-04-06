#
# Be sure to run `pod lib lint EasyImageVideoPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyImageVideoPicker'
  s.version          = '0.1.0'
  s.summary          = 'EasyImageVideoPicker is the easy and simple image and video picker from your device'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'EasyImageVideoPicker is the easy and simple image and video picker from your device'
                       DESC

  s.homepage         = 'https://github.com/avijitmobi/EasyImageVideoPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Avijit Babu' => 'avijitmobi@gmail.com' }
  s.source           = { :git => 'https://github.com/avijitmobi/EasyImageVideoPicker.git', :tag => '0.1.0' }
  s.swift_version = '5.0'
  s.ios.deployment_target  = '12.0'
  # s.platforms = {
  #    "ios" : "12.0"
  # }
  s.social_media_url = 'https://github.com/avijitmobi'
  s.source_files = 'MyOwnFiles/**/*'
  
  # s.resource_bundles = {
  #   'EasyImageVideoPicker' => ['EasyImageVideoPicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation',"AVKit","Photos"
  # s.dependency 'AFNetworking', '~> 2.3'
end
