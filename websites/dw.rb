
register_website(
  name: 'dw',
  test: -> (uri) {
    uri.hostname == 'www.dw.com'
  },
  process: -> (html) {
    document = Nokogiri::HTML(html)
    title = document.css('#bodyContent h1').first.content
    author = ''
    content = document.css('#bodyContent').first

    content.css('h1').first.remove
    content.css('.artikel').first.remove
    content.css('#sharing-bar').first.remove

    {
      title: title,
      author: author,
      content: content.to_html.lines.map(&:strip).join
    }
  }
)