module Cukehead

  class FreemindWriter

    def add_newline_after_tags(xml)
      t = ""
      xml.each_char {|c| c == ">" ? t << c + "\n" : t << c}
      return t
    end


    def write_mm(filename, mmxml)
      s = add_newline_after_tags mmxml
      File.open(filename, 'w') do |f|
        f.write(s)
      end
    end

  end

end
