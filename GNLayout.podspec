Pod::Spec.new do |s|
  s.name                  = "GNLayout"
  s.version               = "0.1"
  s.summary               = "GNLayout for iOS"
  s.description           = <<-DESC
                            GNLayout provides:
                            * Flexible view system with auto-layout
                            * State machine
                            * KVC for NSObject based models
                            DESC
  s.homepage              = "https://www.linkedin.com/in/reformer"
  s.author                = { "Gabor Nagy" => "gabor.nagy.0814@gmail.com" }
  s.license               = 'MIT'
  s.source                = { :git => "https://reformer_ssh@bitbucket.org/calstore/calstorekit.git", :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.requires_arc          = true
  s.source_files          = "Source/**/*.{h,swift}"
  s.weak_frameworks       = "UIKit"
end
