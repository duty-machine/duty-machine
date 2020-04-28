register_website(
  name: 'chinadigitaltimes',
  test: -> (uri) {
    uri.hostname == 'chinadigitaltimes.net'
  },
  process: -> (html) {
    document = Nokogiri::HTML(html)
    title = document.css('h1').first.content
    author = document.css('a[rel=author]').first.content
    content = document.css('div.post-content').first

    {
      title: title,
      author: author,
      content: content.to_html.lines.map(&:strip).join
    }
  }
)