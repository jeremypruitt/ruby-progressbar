Gem::Specification.new do |s|
  s.name = "ruby-progressbar"
  s.version = "0.1.0"

  s.author = "Satoru Takabayashi"
  s.date = "2009-02-16"
  s.description = "Ruby/ProgressBar is a text progress bar library for Ruby."
  s.email = "satoru@namazu.org"
  s.files = %w[GPL_LICENSE RUBY_LICENSE README.md lib/progressbar.rb lib/db_output.rb  lib/dbprogressbar.rb lib/sequel_output.rb test.rb test_sequel.rb]
  s.homepage = "http://github.com/nex3/ruby-progressbar"
  s.require_paths = ["lib"]
  s.summary = <<END
Ruby/ProgressBar is a text progress bar library for Ruby.
It can indicate progress with percentage, a progress bar,
and estimated remaining time.
END
end
