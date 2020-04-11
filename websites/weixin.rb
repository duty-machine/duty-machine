
register_website(
  name: 'telegraph',
  test: -> (uri) {
    uri.hostname == 'mp.weixin.qq.com'
  },
  process: -> (document) {
    title = document.css('#activity-name').first.content.strip
    author = document.css('#js_name').first.content.strip
    content = document.css('#js_content').first

    content.traverse{|x|
      x.remove_class
      x.remove_attribute('id')
      x.remove_attribute('style')
      if x.name == 'img'
        unless x['src']
          x['src'] = x['data-src']
        end
      end
    }

    {
      title: title,
      author: author,
      content: content.to_html.lines.map(&:strip).join
    }
  }
)