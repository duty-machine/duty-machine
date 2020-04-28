register_website(
  name: 'matters.news',
  test: -> (uri) {
    uri.hostname == 'matters.news'
  },
  process: -> (html) {
    document = Nokogiri::HTML(html)
    title = document.css('h1.article').first.content
    author = document.css('a.name').first.content
    content = document.css('div.u-content').first
    content.traverse{|x| x.remove_class}

    {
      title: title,
      author: author,
      content: content.to_html.lines.map(&:strip).join
    }
  }
)