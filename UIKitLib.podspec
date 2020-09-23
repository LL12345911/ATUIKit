#
#  Be sure to run `pod spec lint ATUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

   s.name         = 'UIKitLib'
    s.version      = '1.0.1'
    s.summary      = 'iOS开发基本库'
    s.description  = <<-DESC 
    ***
    iOS开发基本库
    ***
                   DESC
    s.homepage     = 'https://github.com/LL12345911/UIKitLib'
    s.license      = { :type => "MIT", :file => 'LICENSE' }
    s.authors      = { "Mars" => "sky12345911@163.com" }
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/LL12345911/UIKitLib.git', :tag => s.version}
    s.social_media_url = 'https://github.com/LL12345911/UIKitLib'
    s.source_files = 'UIKitLib/*.{h,m}'
   

     s.subspec 'UIImage' do |ss|
    ss.source_files = 'UIKitLib/UIImage/*.{h,m}'
    end

    s.subspec 'UIScrollView' do |ss|
    ss.source_files = 'UIKitLib/UIScrollView/*.{h,m}'
    end

    s.subspec 'ToastView' do |ss|
    ss.source_files = 'UIKitLib/ToastView/*.{h,m}'
    end

    s.subspec 'UILabel' do |ss|
    ss.source_files = 'UIKitLib/UILabel/*.{h,m}'
    end

    s.subspec 'UIButton' do |ss|
    ss.source_files = 'UIKitLib/UIButton/*.{h,m}'
    end

    s.subspec 'UIColor' do |ss|
    ss.source_files = 'UIKitLib/UIColor/*.{h,m}'
    end

    s.subspec 'UIView' do |ss|
    ss.source_files = 'UIKitLib/UIView/*.{h,m}'
    end

    s.subspec 'UINavigation' do |ss|
    ss.source_files = 'UIKitLib/UINavigation/*.{h,m}'
    end

    s.subspec 'TabBar' do |ss|
    ss.source_files = 'UIKitLib/TabBar/*.{h,m}'
    end
    
    s.subspec 'UITextView' do |ss|
    ss.source_files = 'UIKitLib/UITextView/*.{h,m}'
    end

    s.subspec 'UICollectionView' do |ss|
    ss.source_files = 'UIKitLib/UICollectionView/*.{h,m}'
    end

    s.subspec 'UIImageView' do |ss|
    ss.source_files = 'UIKitLib/UIImageView/*.{h,m}'
    end

    s.subspec 'UIViewController' do |ss|
    ss.source_files = 'UIKitLib/UIViewController/*.{h,m}'
    end

    s.subspec 'UITableView' do |ss|
    ss.source_files = 'UIKitLib/UITableView/*.{h,m}'
    end

    s.subspec 'UISearchBar' do |ss|
    ss.source_files = 'UIKitLib/UISearchBar/*.{h,m}'
    end

    s.subspec 'ATFPSButton' do |ss|
    ss.source_files = 'UIKitLib/ATFPSButton/*.{h,m}'
    end

    s.subspec 'Wave' do |ss|
    ss.source_files = 'UIKitLib/Wave/*.{h,m}'
    end
 
    s.subspec 'StaticView' do |ss|
    ss.source_files = 'UIKitLib/StaticView/*.{h,m}'
    end

     s.subspec 'UITextField' do |ss|
    ss.source_files = 'UIKitLib/UITextField/*.{h,m}'
    end

    s.requires_arc = true
    s.ios.frameworks = 'UIKit'
    s.ios.deployment_target = '9.0'



end

