class Crawler
  def execute!
    Settings.sites.each do |site|
      feed = Feedjira::Feed.fetch_and_parse(site)
      Article.transaction do
        feed.entries.each do |entry|
          Article.where(url: entry.url).first_or_create!(
            title:        entry.title,
            url:          entry.url,
            content:      entry.content,
            published_at: entry.published
          )
        end
      end
    end
  end
end
