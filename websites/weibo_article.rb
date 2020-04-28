
register_website(
  name: 'weibo_article',
  test: -> (uri) {
    uri.hostname == 'www.weibo.com' && uri.path.start_with?('/ttarticle')
  },
  request: ->(uri) {
    id = CGI.parse(uri.query)['id'][0]

    headers = {
      'Referer' => "https://card.weibo.com/article/m/show/id/#{id}",
      'User-Agent' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
    }

    get_with_headers(URI("https://card.weibo.com/article/m/aj/detail?id=#{id}"), headers)
  },
  process: -> (res) {
    data = JSON.parse(res)['data']

    {
      title: data['title'],
      author: data['userinfo']['screen_name'],
      content: data['content'].lines.map(&:strip).join
    }
  }
)