Pod::Spec.new do |spec|

  spec.name = 'Layoutable'
  spec.version = '1.0.0'
  spec.summary = 'Extension for UIView apps that make use of AutoLayout easier.'
  spec.homepage = 'https://github.com/MichalTKwiecien/Layoutable'

  spec.license = { type: 'MIT', file: 'LICENSE.md' }
  spec.authors = { 'Michał Kwiecień' => 'michal@kwiecien.co' }
  spec.source = { git: 'https://github.com/MichalTKwiecien/Layoutable.git', tag: spec.version.to_s }

  spec.source_files = 'Layoutable/**/*.swift'

  spec.requires_arc = true
  spec.frameworks = 'UIKit'

  spec.swift_version = '4.1'
  spec.ios.deployment_target = '9.0'

end
