Pod::Spec.new do |s|
  s.name             = "JSKTimerView"
  s.version          = "0.1.8"
  s.summary          = "A simple custom UIView that acts as a self-contained, animating timer."
  s.homepage         = "https://github.com/jeffkibuule/JSKTimerView"
  s.screenshots      = ['https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Screenshots/screenshot0.png', 'https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Screenshots/screenshot1.png', 'https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Screenshots/screenshot2.png', 'https://raw.githubusercontent.com/jeffkibuule/JSKTimerView/master/Screenshots/screenshot3.png']
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
