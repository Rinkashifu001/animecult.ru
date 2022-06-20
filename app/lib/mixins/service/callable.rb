# frozen_string_literal: true

module Mixins
  module Service
    module Callable
      def call(*args)
        new(*args).call
      end
    end
  end
end
