module Cukehead
  class App
    attr_accessor :features_path

    def initialize
      @features_path = File.join(Dir.getwd, 'features')
    end

    def run

    end

  end
end