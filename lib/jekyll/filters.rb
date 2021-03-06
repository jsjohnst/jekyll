module Jekyll
  
  module Filters
    def textilize(input)
      RedCloth.new(input).to_html
    end

    def date_to_rfc2822(date)
      date.rfc2822
    end
    
    def date_to_string(date)
      date.strftime("%d %b %Y")
    end

    def archivedate_to_string(date)
      Time.parse("01-" + date).strftime("%B %Y")
    end

    def date_to_long_string(date)
      date.strftime("%d %B %Y")
    end
    
    def date_to_xmlschema(date)
      date.xmlschema
    end
    
    def xml_escape(input)
      input.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")
    end
    
    def number_of_words(input)
      input.split.length
    end
    
    # Returns all content before the first-encountered <hr /> tag.
    # Allows authors to mark the fold with an hr in their drafts.
    # e.g. {{ content | before_fold }}
    def before_fold(input)
      input.split("<hr").first
    end
    
    def array_to_sentence_string(array)
      connector = "and"
      case array.length
      when 0
        ""
      when 1
        array[0].to_s
      when 2
        "#{array[0]} #{connector} #{array[1]}"
      else
        "#{array[0...-1].join(', ')}, #{connector} #{array[-1]}"
      end
    end

    def html_truncatewords(input, words = 15, truncate_string = "...")
      doc = Hpricot.parse(input)
      (doc/:"text()").to_s.split[0..words].join(' ') + truncate_string
    end


    def strip_html_suffix(input)
      input.gsub(/\.html$/, '')
    end

    def gist(id)
      js = open("http://gist.github.com/#{id}.js").read
      js.match(/document.write\('(<div.+)'\)/)[1].gsub(/\\"/, '"').gsub(/\\\//, '/').gsub(/\\n/, '')
    end
    
    def educate(input)
      Smartypants.educate_string(input)
    end

    def markdown(input)
      Maruku.new(input).to_html
    end
  end  

  # Maruku, inexplicably, offers no way to access its Smartypants
  # implementation outside of the Markdown interface. So here's a hack.
  class Smartypants; end
  class << Smartypants
    include MaRuKu::In::Markdown::SpanLevelParser
    include MaRuKu::Helpers
    def educate_string(s)
      educate([s]).map{ |x| x.to_html_entity rescue x }.join
    end
  end
end
