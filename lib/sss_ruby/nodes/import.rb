module SSS
  class Import
    def initialize(file)
      @file = file.gsub("'", "").gsub("\"","")
    end

    def to_css(context)
      raise "File does not exist!" unless File.exist?(@file)
      sss = File.read(@file)
      raise "Empty file." if sss.empty?
      SSS::Engine.new.compile(sss) unless sss.empty?
    end

    def ==(other)
      other.class == self.class && other.state == self.state
    end

    protected
    def state
      @file
    end
  end
end
