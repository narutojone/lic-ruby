class Sanitize
  module Config
    WHITELIST = {
      tags: %w(
        p blockquote pre
        h1 h2 h3 h4 h5 h6
        a
        span
        b i u em
        br hr
        font small strike strong sub sup
        img
        ul ol li
        table thead tbody th tr td
      ),
      attributes: %w(class style src href)
    }.freeze

    ALL_DISALLOWED = {
      tags: [],
      attributes: []
    }.freeze
  end
end
