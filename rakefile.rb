require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'FQuery'
  m.language                = 'as3'
  m.background_color        = '#FFFFFF'
  m.width                   = 970
  m.height                  = 550
  # m.src_dir               = 'src'
  # m.lib_dir               = 'lib'
  # m.swc_dir               = 'lib'
  # m.bin_dir               = 'bin'
  # m.test_dir              = 'test'
  # m.doc_dir               = 'doc'
  # m.asset_dir             = 'assets'
  # m.compiler_gem_name     = 'sprout-flex4sdk-tool'
  # m.compiler_gem_version  = '>= 4.0.0'
  # m.source_path           << "#{m.lib_dir}/somelib"
  # m.libraries             << :corelib
end

desc 'Compile and run the example'
flashplayer :example => 'bin/FQueryExample.swf'

mxmlc 'bin/FQueryExample.swf' do |t|
  t.input = 'src/FQueryExample.as'
end

desc 'Compile run the test harness'
unit :test

desc 'Create documentation'
document :doc

desc 'Compile and run from cruise control'
ci :cruise

desc 'Compile a SWC file'
swc :swc

# set up the default rake task
task :default => :debug
