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
=begin
  get = Net::HTTP::Get.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, {use_ssl: uri.scheme == 'https'}) { |http|
    http.request_get(uri, 'User-Agent' => "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/12.0 Mobile/15A372 Safari/604.1")
  }
=end
  document = Nokogiri::HTML(html)
  process.(document)
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
