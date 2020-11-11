#
# Be sure to run `pod lib lint Transform.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Transform'
  s.version          = '0.1.4'
  s.summary          = 'A simple crash protection kit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/Cyb3rtr0n-s/Transform'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wayne' => 'waynesun1990@gmail.com' }
  s.source           = { :git => 'https://github.com/Cyb3rtr0n-s/Transform.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.default_subspec = 'Core'
  
  # s.source_files = 'Transform/Classes/**/*'

  s.subspec 'Core' do |core|
    core.source_files = 'Transform/Classes/Core/**/*'
    core.public_header_files = 'Transform/Classes/Core/**/*.{h}'
  end

  s.subspec 'UnrecognizedSelector' do |unrecognized|
    unrecognized.source_files = 'Transform/Classes/UnrecognizedSelector/**/*'
    unrecognized.public_header_files = 'Transform/Classes/UnrecognizedSelector/**/*.{h}'
    unrecognized.dependency 'Transform/Core'
  end

  s.subspec 'Container' do |container|
    container.source_files = 'Transform/Classes/Container/**/*'
    container.public_header_files = 'Transform/Classes/Container/**/*.{h}'
    container.dependency 'Transform/Core'
  end

  s.subspec 'Timer' do |timer|
    timer.source_files = 'Transform/Classes/Timer/**/*'
    timer.public_header_files = 'Transform/Classes/Timer/**/*.{h}'
    timer.dependency 'Transform/Core'
  end

  s.subspec 'KVO' do |kvo|
    kvo.source_files = 'Transform/Classes/KVO/**/*'
    kvo.public_header_files = 'Transform/Classes/KVO/**/*.{h}'
    kvo.dependency 'Transform/Core'
  end

  s.subspec 'Zombie' do |zombie|
    zombie.source_files = 'Transform/Classes/Zombie/**/*'
    zombie.public_header_files = 'Transform/Classes/Zombie/**/*.{h}'
    zombie.dependency 'Transform/Core'
  end
end
