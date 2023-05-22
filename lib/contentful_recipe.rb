class ContentfulRecipe < Contentful::Entry
  def tags
    fields[:tags]&.map(&:name)&.join(', ') || 'TBD'
  end

  def title
    fields[:title]
  end

  def chef_name
    fields[:chef]&.name&.strip || 'Anonymous Chef Lol'
  end

  def image_url
    fields[:photo]
      .url(width: 300, height: 200, format: 'jpg', quality: 100)
      .sub %r{\A//}, 'https://'
  end

  def description_markdown
    fields[:description]
  end

  def description_html
    # just using lines in redcarpet gem examples, not fully tested the options against all sorts of markdown formats
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    markdown.render(description_markdown).html_safe
  end
end
