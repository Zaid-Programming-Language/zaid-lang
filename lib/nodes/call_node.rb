# frozen_string_literal: true

module Zaid
  module Nodes
    CallNode = Struct.new(:receiver, :method_name, :arguments)
  end
end
