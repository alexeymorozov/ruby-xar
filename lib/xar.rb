require "ffi"
require "ffi/stat"

module Xar
  def self.open(path, flag)
    xar_t = Xar::Native.xar_open(path, flag)

    Xar::Archive.new(xar_t)
  end
end

require "xar/native"
require "xar/archive"
