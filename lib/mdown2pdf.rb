require "mdown2pdf/pseudo_code_lexer"
require "mdown2pdf/render"
require "mdown2pdf/version"

module Mdown2PDF
  extend self

  # Creates a temporary file to store the Markdown document once it's
  # parsed so Wkhtmltopdf can render it.
  def temporary_html_file_for(file)
    path = "/tmp/output-#{(rand * 100).round}.html"

    File.open(path, "w") do |f|
      f.write('<!DOCTYPE html>')
      f.write('<html>')
      f.write('<head>')
      f.write('<meta charset="utf-8">')
      f.write('</head>')
      f.write('<body><div class="markdown-body" style="width: 960px; margin: auto">')
      f.write(markdown_for(file))
      f.write('</div></body>')
    end

    yield(path)
  ensure
    File.delete(path)
  end

  # Actually outputs a given HTML file as a PDF for a given name
  # through the `wkhtmltopdf` command line tool.
  def output(file: , name: )
    arguments = [
      "wkhtmltopdf",
      file,
      "--include-in-outline",
      "--enable-internal-links",
      "--user-style-sheet", asset('style.css'),
      name.sub(/.(md|mdwon)/, '.pdf')
    ]

    `#{arguments.join(" ")}`
  end

  # Converts a given Markdown file to an HTML document. The underlying
  # implementation uses Redcarpet but you should check out the +Render+
  # class for further information.
  def markdown_for(file)
    html_for(File.read(file))
  end

  # Converts a given Markdown string to HTML.
  def html_for(markdown)
    parser = Redcarpet::Markdown.new(Render, {
      fenced_code_blocks: true,
      tables:             true,
      superscript:        true,
      strikethrough:      true,
      autolink:           true
    })

    parser.render(markdown)
  end

  # Returns an absolute path for a given asset.
  def asset(name)
    File.expand_path(File.join(__dir__, '..', 'assets', name))
  end
end
