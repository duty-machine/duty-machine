require 'nokogiri'
require 'octokit'
require 'uri'
require 'net/http'

WEBSITES = []

def register_website config
  WEBSITES << config
end

Dir["#{__dir__}/websites/*.rb"].each{|path| require path}

def fetch_article url
  uri = URI(url)
  if website = WEBSITES.find{|x| x[:test].(uri) }
    process = website[:process]
  else
    process = -> (document) {
      article = document.css('article').first
      title = document.css('title').first.content

      {
        title: title,
        author: nil,
        content: article.to_html
      }
    }
  end
  html = Net::HTTP.get(uri)
  document = Nokogiri::HTML(html)
  process.(document)
end

def article_data url
  uri = URI(url)
  raise unless uri.hostname == 'matters.news'
  raise unless uri.path.match /\/@.+?\/.+?$/
  html = Net::HTTP.get(uri)
  document = Nokogiri::HTML(html)
  title = document.css('h1.article').first.content
  author = document.css('a.name').first.content
  content = document.css('div.u-content').first
  content.traverse{|x| x.remove_class}
  content = content.to_html

  [title, author, content]
end

def run token, repo
  client = Octokit::Client.new(access_token: token)
  client.list_issues(repo, state: 'open').each do |issue|
    begin
      number = issue[:number]
      title = issue[:title]
      body = issue[:body]

      if title == 'archive_request'
        article = fetch_article(body)
        client.add_comment(repo, number, "#{article[:title]} by #{article[:author]}\n------\n#{article[:content]}")
        client.update_issue(repo, number, title: article[:title], labels: ['fetched'])
      else
        raise 'invalid request'
      end
    rescue
      client.add_comment(repo, number, $!.inspect)
      client.update_issue(repo, number, labels: ['error'])
    ensure
      client.close_issue(repo, number)
    end
  end
end
