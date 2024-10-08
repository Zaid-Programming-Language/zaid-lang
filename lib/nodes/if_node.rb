# frozen_string_literal: true

module Zaid
  module Nodes
    IfNode = Struct.new(:condition, :body, :else_body)
  end
end
