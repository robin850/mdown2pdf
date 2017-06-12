require "test_helper"

class Mdown2PDFTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mdown2PDF::VERSION
  end

  def test_asset_paths_are_valid
    assert File.exist?(Mdown2PDF.asset('style.css'))
  end

  def test_html_for_yields_markdown_for_a_given_string
    assert_includes Mdown2PDF.html_for("**Hello**"), "<strong>Hello</strong>"
  end
end
