
register_website(
  name: 'dw',
  test: -> (uri) {
    uri.hostname == 'www.dw.com'
  },
  process: -> (html) {
    document = Nokogiri::HTML(html)
    title = document.css('#bodyContent h1').first.content
    author = ''
    content = document.css('#bodyContent .longText').first

    content.css('.picBox').each do |el|
      if el.css('a').first
        img = el.css('img').first
        img['src'] = "https://www.dw.com#{img['src']}"
        el.css('a').first.replace(img)
      else
      end
    end

    content.css('script').each(&:remove)

    {
      title: title,
      author: author,
      content: content.to_html.lines.map(&:strip).join
    }
  }
)