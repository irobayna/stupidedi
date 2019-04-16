require File.dirname(__FILE__) + "/lib/stupidedi/version"

Gem::Specification.new do |s|
  s.name        = "stupidedi"
  s.summary     = "Parse, generate, validate ASC X12 EDI"
  s.description = "Ruby API for parsing and generating ASC X12 EDI transactions"
  s.homepage    = "https://github.com/irobayna/stupidedi"

  s.version = Stupidedi::VERSION
  s.date    = "2018-05-27"
  s.author  = "Kyle Putnam/Isi Robayna"
  s.email   = "irobayna@gmail.com"

  s.files             = ["README.md", "Rakefile",
                         "bin/*",
                         "lib/**/*",
                         "doc/**/*.md",
                         "spec/**/*"].map { |glob| Dir[glob] }.flatten
  s.test_files        = Dir["spec/examples/**/*.example"].to_a
  s.bindir            = "bin"
  s.executables       = ["edi-pp", "edi-ed"]
  s.require_path      = "lib"

  s.add_dependency "term-ansicolor", "~> 1.3"
  s.add_dependency "cantor",         "~> 1.2.1"
  # s.metadata["yard.run"] = "yard doc"
end
