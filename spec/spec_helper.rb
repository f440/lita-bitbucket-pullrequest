require "lita-bitbucket-pullrequest"
require "lita/rspec"

def fixture(filename)
  File.read(File.join(__dir__, "fixtures", "#{filename}.json"))
end
