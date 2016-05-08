# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'

use_frameworks!

target 'Trend' do
  pod "Himotoki", "~> 1.3"
  pod 'SWXMLHash', '~> 2.1.0'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'RealmSwift'
  pod 'SwiftDate'
  pod 'MMMarkdown'
end

target 'TrendTests' do
end

target 'TrendUITests' do

end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Trend/Pods-Trend-Acknowledgements.markdown', 'Acknowledgements.markdown', :remove_destination => true)
end
