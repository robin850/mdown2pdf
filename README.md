# Mdown2PDF - Convert Markdown documents to PDF

This tiny project is a wrapper around the following libraries to generate PDF from
Markdown files:

* [Redcarpet](https://github.com/vmg/redcarpet) : to parse Markdown and produce HTML.
* [Rouge](https://github.com/jneen/rouge) : to support syntax highlighting.
* [wkhtmltopdf](https://wkhtmltopdf.org/) : to transform the HTML markup to a PDF file.

> **Important note**: This project has been designed for my personal need; it's far
> from being perfect but feel free to fork it to fit to yours. ❤️

## Installation

Add this line to your application's Gemfile:

~~~ruby
gem 'mdown2pdf'
~~~

And then execute:

~~~
$ bundle
~~~

Or install it yourself as:

~~~
$ gem install mdown2pdf
~~~

## Usage

This gems provides a command line utility to easily convert your Markdown files
to PDF. For example:

~~~
$ md2pdf resume.md
~~~

Will produce a file called resume.pdf, properly styled with a table of contents.
You can specify the output file and even opt out from the default table of contents
generation with the following options:

~~~
$ md2pdf resume.md -o my_resume.pdf --skip-toc
~~~

## Contributing

Bug reports and pull requests are welcome on GitHub. If you are willing to send
a patch:

1. Fork this project.
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
