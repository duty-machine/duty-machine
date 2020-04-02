require 'nokogiri'
require 'octokit'
require 'uri'
require 'net/http'

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
  client.list_issues(repo, state: 'open', labels: 'archive').each do |issue|
    begin
      number = issue[:number]
      title = issue[:title]
      body = issue[:body]

      if title == 'archive_request'
        article_title, article_author, article_content = article_data(body)
        client.add_comment(repo, number, "#{article_title} by #{article_author}\n------\n#{article_content}")
        client.update_issue(repo, number, title: article_title, labels: ['fetched'])
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
