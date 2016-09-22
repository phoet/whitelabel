require "whitelabel/version"
require "whitelabel/handler"

require "yaml"

module Whitelabel
  class << self
    include Whitelabel::Handler
  end
end
