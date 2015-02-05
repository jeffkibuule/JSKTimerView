#
# Be sure to run `pod lib lint JSKTimerView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JSKTimerView"
  s.version          = "0.1.0"
  s.summary          = "A simple custom UIView that acts as a timer."
  s.homepage         = "https://github.com/jeffkibuule/JSKTimerView"
  s.screenshots      = ['https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Screenshots/screenshot0.png']
  s.license          = 'MIT'
  s.author           = { "Joefrey Kibuule" => "jeff.kibuule@outlook.com" }
  s.source           = { :git => "https://github.com/jeffkibuule/JSKTimerView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/jeffkibuule'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'JSKTimerView' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'
end
