require 'rouge'

module Mdown2PDF
  class PseudoCodeLexer < Rouge::RegexLexer
    tag 'pseudo'
    title 'Pseudo Code'

    def self.keywords
      @keywords ||= Set.new %w(
        fonction programme tant que faire si alors sinon fin jusqu à
        ce début procédure pour allant de pas et chaque non dans
      )
    end

    def self.declaration_keywords
      @declaration_keywords ||= Set.new %w(
        var Entrée Sortie
      )
    end

    def self.types
      @types ||= Set.new %w(
        Graphe Sommet
      )
    end

    state :whitespace do
      rule /\s+/m, Text
      rule %r{(//).*$\n}, Comment::Single
    end

    state :literal do
      rule /"(\\.|.)*?"/, Str::Double
      rule /'(\\.|.)*?'/, Str::Single

      rule /(\.\.)/,  Punctuation

      rule %r((\d+[.]\d+)), Num::Float
      rule /\d+/, Num

      rule /(\+|\-|\*|\/\/?|\*\*?)/, Operator

      rule /(<=?|>=?|==|!=)/, Operator
      rule %r{∞}, Operator

      rule /,/,  Punctuation
      rule /:/,  Punctuation
      rule /\[/, Punctuation
      rule /\]/, Punctuation
      rule /\(/, Punctuation
      rule /\)/, Punctuation
      rule /;/, Punctuation
      rule /\|\_/, Punctuation
      rule /\_\|/, Punctuation
      rule /\|/, Punctuation
      rule %r{'}, Punctuation
      rule %r{=}, Punctuation
      rule %r{\{|\}}, Punctuation

      rule /(\+|\-|\*|\/\/?|\*\*?)/, Operator
    end

    state :root do
      mixin :whitespace
      mixin :literal

      rule /(vrai|faux|nul|Nil)\b/i, Name::Builtin

      rule /([[:alpha:]]([[:alnum:]](_[[:alnum:]])?)*)/ do |m|
        name = m[0]

        if self.class.keywords.include? name
          token Keyword
        elsif self.class.declaration_keywords.include? name
          token Keyword::Declaration
        elsif self.class.types.include? name
          token Keyword::Type
        else
          token Name
        end
      end
    end
  end
end
