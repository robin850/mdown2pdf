require 'redcarpet'

module Mdown2PDF
  # Custom Redcarpet render object that adds the following to the
  # default stack:
  #
  #  * Code highlighting (through Rouge).
  #  * Automatic expanding for image paths (since Wkhtmltopdf requires
  #    absolute paths).
  #  * Anchor generation for titles.
  #  * Possibility to use "`#hexcode`" to generate a div with the specified
  #    value as the background color.
  #
  # It is a drop-in replacement for any Redcarpet render object that procuces
  # HTML.
  class Render < Redcarpet::Render::HTML
    def block_code(code, lang)
      lexer = Rouge::Lexer.find_fancy(lang, code) || Rouge::Lexers::PlainText

      if lexer.tag == 'make'
        code.gsub! /^  /, "\t"
      end

      %(<div class="highlight"><pre>#{Rouge::Formatters::HTML.new.format(lexer.lex(code))}</pre></div>)
    end

    def codespan(code)
      if code.start_with?("#")
        %(<div style="height: 20px; margin: auto; width: 40px; background: #{code}"></div>)
      else
        %(<code>#{code}</code>)
      end
    end

    def header(text, level)
      alphabet = ['a'..'z'] + []

      anchor = text.chars.keep_if do |c|
        c =~ /[[:alpha:]]/ || c == ''
      end.join("")

      %(<h#{level} id="#{anchor.downcase.gsub(' ', '-')}">#{text}</h#{level}>)
    end

    def image(link, title, text)
      %(<img src="#{Dir.pwd}/#{link}">)
    end
  end
end
