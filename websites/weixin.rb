
register_website(
  name: 'telegraph',
  test: -> (uri) {
    uri.hostname == 'mp.weixin.qq.com'
  },
  process: -> (document) {
    title = document.css('#activity-name').first.content.strip
    author = document.css('#js_name').first.content.strip
    content = document.css('#js_content').first

    {
      title: title,
      author: author,
      content: content.to_html
    }
  }
)