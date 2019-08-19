# -*- encoding: utf-8 -*-
# stub: discard 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "discard".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Hawthorn".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-03-16"
  s.description = "Allows marking ActiveRecord objects as discarded, and provides scopes for filtering.".freeze
  s.email = ["john.hawthorn@gmail.com".freeze]
  s.homepage = "https://github.com/jhawthorn/discard".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "ActiveRecord soft-deletes done right".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, ["< 6", ">= 4.2"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.14"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_development_dependency(%q<database_cleaner>.freeze, ["~> 1.5"])
      s.add_development_dependency(%q<with_model>.freeze, ["~> 2.0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, ["< 6", ">= 4.2"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.14"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
      s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.5"])
      s.add_dependency(%q<with_model>.freeze, ["~> 2.0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, ["< 6", ">= 4.2"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.14"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.5.0"])
    s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.5"])
    s.add_dependency(%q<with_model>.freeze, ["~> 2.0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
  end
end
