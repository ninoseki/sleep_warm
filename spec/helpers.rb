require "json"

module Helpers
  def io_to_queue(io)
    io.rewind
    io.readlines.map { |line| JSON.parse line }
  end
end
