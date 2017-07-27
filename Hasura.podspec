Pod::Spec.new do |spec|
  spec.name         = "Hasura"
  spec.version      = "v0.0.1"
  spec.summary      = "The iOS SDK for Hasura written in Swift"
  spec.license      = { :type => "MIT", :file => "LICENSE"}
  spec.author       = { "Jaison Titus" => "jaison@hasura.io" }
  spec.source       = { :git => "https://github.com/hasura/iOS-sdk.git", :tag => spec.version }
  spec.requires_arc = 'true'
  spec.default_subspec = "Core"

  spec.subspec "Core" do |ss|
    ss.source_files  = "Sources/Moya/", "Sources/Moya/Plugins/"
    ss.dependency "Alamofire", "~> 4.1"
    ss.dependency "Result", "~> 3.0"
    ss.framework  = "Foundation"
  end

  s.subspec "ReactiveCocoa" do |ss|
    ss.dependency "Moya/ReactiveSwift"
  end

  s.subspec "ReactiveSwift" do |ss|
    ss.source_files = "Sources/ReactiveMoya/"
    ss.dependency "Moya/Core"
    ss.dependency "ReactiveSwift", "~> 1.1"
  end

  s.subspec "RxSwift" do |ss|
    ss.source_files = "Sources/RxMoya/"
    ss.dependency "Moya/Core"
    ss.dependency "RxSwift", "~> 3.0"
  end
end
