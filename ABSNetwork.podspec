Pod::Spec.new do |s|
  s.name                    = "ABSNetwork"
  s.version                 = "1.0.0"
  s.summary                 = "A network foundation framework based on Alamorefire and ObjectMapper"
  s.license                 = "MIT"
  s.homepage                = "https://github.com/kunwang/absnetwork"
  s.author                  = { "abstractwang" => "abstractwang@gmail.com" }
  s.ios.deployment_target   = '9.0'
  s.source                  = { :git => "https://github.com/kunwang/absnetwork.git", :tag => s.version }
  s.source_files            = "Sources", "ABSNetwork/**/*.{swift}"
  s.resources               = "Resources", "ABSNetwork/**/*.{plist,sqlite3}"
  s.dependency 'Alamofire', '~> 4.5.1'
  s.dependency 'ObjectMapper', '~> 2.2'
end