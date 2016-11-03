Pod::Spec.new do |s|
  s.name             = "iMessageTools"
  s.version          = "1.0"
  s.summary          = "Tools for Swift iMessage development."
  s.homepage         = "https://github.com/jwitcig/iMessageTools"
  s.license          = 'Code is MIT.'
  s.author           = { "Jonah" => "jwitcig@gmail.com" }
  s.source           = { :git => "https://github.com/jwitcig/iMessageTools.git", :tag => s.version }
  s.social_media_url = 'https://twitter.com/jonahwitcig'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'iMessagePack/**/*'
  # s.resources = 'Pod/Assets/*'

  s.frameworks = 'UIKit'
  s.module_name = 'iMessageTools'

  s.dependency 'SwiftTools'
end
