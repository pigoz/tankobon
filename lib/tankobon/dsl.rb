module Tankobon
  module DSL
    def recipe (&block)
      app = Tankobon::Application.new
      block.arity < 1 ? app.instance_eval(&block) : block.call(app) if
        block_given?
    end
  end
end