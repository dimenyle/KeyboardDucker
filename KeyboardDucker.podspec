Pod::Spec.new do |spec|

spec.platform = :ios
spec.ios.deployment_target = '12.0'
spec.name = "KeyboardDucker"
spec.summary = "KeyboardDucker offers a clean and lightweight solution for ensuring that the currently active text field never gets obscured by the keyboard."
spec.requires_arc = true
spec.version = "0.1.1"
spec.license = { :type => "MIT", :file => "LICENSE" }
spec.author = { "Levente Dimény" => "leventedimeny@gmail.com" }
spec.homepage = "https://github.com/dimenyle/KeyboardDucker"
spec.source = { :git => "https://github.com/dimenyle/KeyboardDucker.git",
:tag => "#{spec.version}" }
spec.framework = "UIKit"
spec.source_files = "KeyboardDucker/**/*.{swift}"
spec.swift_version = "5.0"

end
