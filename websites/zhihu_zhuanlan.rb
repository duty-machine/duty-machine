register_website(
  name: 'default',
  test: -> (uri) {
    uri.hostname == 'zhuanlan.zhihu.com'
  },
  request: -> (uri) {
    headers = {
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:74.0) Gecko/20100101 Firefox/74.0'
    }

    get_with_headers(uri, headers)
  },
  process: -> (html) {
    document = Nokogiri::HTML(html)

    title = document.css('h1.Post-Title').first.content
    author = document.css('meta[itemprop=name]').first['content']

    content = document.css('.Post-RichTextContainer').first

    {
      title: title,
      author: author,
      content: content.to_html.lines.map(&:strip).join
    }
  }
)