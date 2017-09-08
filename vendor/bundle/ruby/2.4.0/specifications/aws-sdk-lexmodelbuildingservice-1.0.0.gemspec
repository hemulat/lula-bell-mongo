# -*- encoding: utf-8 -*-
# stub: aws-sdk-lexmodelbuildingservice 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "aws-sdk-lexmodelbuildingservice".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Amazon Web Services".freeze]
  s.date = "2017-08-29"
  s.description = "Official AWS Ruby gem for Amazon Lex Model Building Service. This gem is part of the AWS SDK for Ruby.".freeze
  s.email = ["trevrowe@amazon.com".freeze]
  s.homepage = "http://github.com/aws/aws-sdk-ruby".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "2.6.12".freeze
  s.summary = "AWS SDK for Ruby - Amazon Lex Model Building Service".freeze

  s.installed_by_version = "2.6.12" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<aws-sdk-core>.freeze, ["~> 3"])
      s.add_runtime_dependency(%q<aws-sigv4>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<aws-sdk-core>.freeze, ["~> 3"])
      s.add_dependency(%q<aws-sigv4>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<aws-sdk-core>.freeze, ["~> 3"])
    s.add_dependency(%q<aws-sigv4>.freeze, ["~> 1.0"])
  end
end
