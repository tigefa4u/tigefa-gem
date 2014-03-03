# Gist Liquid Tag
#
# Example:
#    {% gist 1234567 %}
#    {% gist 1234567 file.rb %}

module Tigefa
  class PastebinTag < Liquid::Tag

    def render(context)
      if tag_contents = determine_arguments(@markup.strip)
        pastebin_id, filename = tag_contents[0], tag_contents[1]
        pastebin_script_tag(pastebin_id, filename)
      else
        "Error parsing gist id"
      end
    end

    private

    def determine_arguments(input)
      matched = if input.include?("/")
        input.match(/\A([a-zA-Z0-9\/\-_]+) ?(\S*)\Z/)
      else
        input.match(/\A(\d+) ?(\S*)\Z/)
      end
      [matched[1].strip, matched[2].strip] if matched && matched.length >= 3
    end

    def pastebin_script_tag(pastebin_id, filename = nil)
      if filename.empty?
        "<script src=\"https://gist.github.com/#{gist_id}.js\"> </script>"
      else
        "<script src=\"https://gist.github.com/#{gist_id}.js?file=#{filename}\"> </script>"
      end
    end
  end
end

Liquid::Template.register_tag('pastebin', Tigefa::PastebinTag)