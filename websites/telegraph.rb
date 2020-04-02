
register_website(
  name: 'telegraph',
  test: -> (uri) {
    uri.hostname == 'telegra.ph'
  },
  process: -> (document) {
    title = document.css('header h1').first.content
    author = document.css('header a[rel=author]').first.content
    content = document.css('article').first

    {
      title: title,
      author: author,
      content: content.to_html
    }
  }
)