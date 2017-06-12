require "mdown2pdf/pseudo_code_lexer"
require "mdown2pdf/render"
require "mdown2pdf/version"

module Mdown2PDF
  extend self

  # Creates two temporary files:
  #
  #  * One to represent the eventual cover of the PDF file.
  #  * One with the document translated to HTML.
  #
  # These two temporary files will be used by Wkhtmltopdf to
  # generate the final PDF file.
  #
  # This method requires a block that will yield a path for each
  # file. For example:
  #
  #   temporary_files_for("a_file.md") do |output, cover|
  #     # Here `output` and `cover` are paths.
  #   end
  #
  # To distinguish the cover from the rest of the document, the
  # user must put an h-rule inside their document and the first
  # one will be used as a separator.
  def temporary_html_files_for(file)
    seed        = (rand * 100).round
    output_file = "/tmp/output-#{seed}.html"
    cover_file  = "/tmp/cover-#{seed}.html"

    document = markdown_for(file)
    first_hr = document.index('<hr>')

    if first_hr
      cover    = document[0..first_hr]
      document = document[first_hr+4..-1]
    end

    File.open(output_file, "w") do |f|
      f.write(File.read(asset('output.html')) % { content: document })
    end

    if cover
      File.open(cover_file, "w") do |f|
        f.write(File.read(asset('output.html')) % { content: cover })
      end

      yield(output_file, cover_file)
    else
      yield(output_file, nil)
    end
  ensure
    File.delete(output_file)
    File.delete(cover_file) if File.exist?(cover_file)
  end

  # Actually outputs a given HTML file as a PDF for a given name
  # through the `wkhtmltopdf` command line tool.
  #
  #  - The given `:file` key represents the HTML file to translate
  #    to PDF.
  #  - `:name` will be used to infer the PDF file's name.
  #  - `:cover` can be used if a document should be used as a cover.
  def output(file: , name: , cover: nil)
    stylesheet = ["--user-style-sheet", asset('style.css')]
    arguments  = ["wkhtmltopdf"]

    if cover
      arguments.push("cover", cover)
      arguments.push(*stylesheet)
    end

    arguments.push(
      file,
      "--include-in-outline",
      "--enable-internal-links",
      *stylesheet,
      name.sub(/.(md|mdwon)/, '.pdf')
    )

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
