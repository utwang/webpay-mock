# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webpay/mock/version'

Gem::Specification.new do |spec|
  spec.name          = "webpay-mock"
  spec.version       = WebPay::Mock::VERSION
  spec.authors       = ["webpay", "tomykaira"]
  spec.email         = ['administrators@webpay.jp', 'tomykaira@webpay.jp']
  spec.description   = 'WebPay::Mock helps development of WebPay client applications'
  spec.summary       = 'Dummy response generator and wrapper of webmock gem for WebPay'
  spec.homepage      = 'https://webpay.jp'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'webmock', '~> 1.13.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webpay', '~> 3.0.0'
end
