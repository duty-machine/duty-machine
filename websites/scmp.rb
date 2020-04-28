
register_website(
  name: 'scmp',
  test: -> (uri) {
    uri.hostname == 'www.scmp.com'
  },
  process: -> (html) {
    document = Nokogiri::HTML(html)
    title = document.css('h1.info__headline.headline').first.content.strip
    subheadline = document.css('.info__subHeadline').first.to_html
    author = document.css('.main-info__name a').first.content
    apollo = document.css('script').find{|x| x.content.start_with?('window.__APOLLO_STATE__=') }.content
    data = apollo.split('\"more-on-this\"')
    article_data = data[1].split(')":')[1]

    count = 0
    index = 0
    article_data.each_char.with_index do |c, i|
      if c == '{'
        count += 1
      elsif c == '}'
        count -= 1
      end
      if count == 0
        index = i
        break
      end
    end
    json = JSON.parse(article_data[0..index])
    arr = json['json']

    recur = -> (obj) {
      case obj
      when Array
        obj.map{|x| recur.(x)}.join
      when Hash
        if obj['type'] == 'text'
          return obj['data']
        end
        attribs = if obj['attribs']
          obj['attribs'].map{|k, v| "#{k}=\"#{v}\""}.join(' ')
        else
          ''
        end
        if obj['children']
          "<#{obj['type']} #{attribs}>#{recur.(obj['children'])}</#{obj['type']}>"
        else
          "<#{obj['type']} #{attribs}>#{obj['data']}</#{obj['type']}>"
        end
      end
    }
    content = recur.(arr)
    content = "#{subheadline}#{content}"

    {
      title: title,
      author: author,
      content: content.lines.map(&:strip).join
    }
  }
)