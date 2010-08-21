module Tankobon
  WORK_PATH = File.expand_path(File.join('~', 'tankobon')) unless
    defined?(::Tankobon::WORK_PATH)
end