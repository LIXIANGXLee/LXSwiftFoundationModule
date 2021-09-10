#
#  Be sure to run `pod spec lint LXSwiftFoundation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "LXSwiftFoundation"
  spec.version      = "8.8.3"
  spec.summary      = "Extend more user-friendly functions for system classes"

  
  spec.description  = <<-DESC
  LXSwiftFoundation is Extend more user-friendly functions for system classes
  DESC

  
    spec.homepage = "https://github.com/LIXIANGXLee/LXSwiftFoundationModule"

    spec.license = "MIT"
    spec.author = { "lixiang" => "1367015013@qq.com" }

    spec.platform = :ios, "9.0"
    spec.swift_version = "5.0"

    spec.source = { :git => "https://github.com/LIXIANGXLee/LXSwiftFoundationModule.git", :tag => "#{spec.version}" }
    
        spec.subspec 'Core' do |core|
            core.source_files = "LXSwiftFoundation/Core/**/*.{swift,h,m}"
        end
        
        spec.subspec 'Objc' do |oc|
            oc.source_files = "LXSwiftFoundation/Objc/**/*.{h,m}"
            oc.dependency 'LXSwiftFoundation/Core'
        end
        
        spec.subspec 'Swift' do |swift|
            swift.source_files = "LXSwiftFoundation/Swift/**/*.swift"
            swift.dependency 'LXSwiftFoundation/Objc'
        end
            
  end

