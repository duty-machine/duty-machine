register_website(
  name: 'epochtimes',
  test: -> (uri) {
    uri.hostname == 'www.epochtimes.com'
  },
  process: -> (html) {
    document = Nokogiri::HTML(html)
    title = document.css('h1.title').first.content
    author = ''
    content = document.css('div#artbody').first

    {
      title: title,
      author: author,
      content: content.to_html.lines.map(&:strip).join
    }
  }
)