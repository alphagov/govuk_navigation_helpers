module GovukNavigationHelpers
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end

  class Configuration
    attr_writer :error_handler

    def initialize
      @configuration = {}
    end

    def error_handler
      @error_handler ||= NoErrorHandler.new
    end

    class NoErrorHandler
      def notify(exception, *_args)
        puts exception
      end
    end
  end
end
