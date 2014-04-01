# Series List Tag
#
# A Jekyll plug-in for embedding a Series List in your Liquid templates.
#
# Usage:
#
#   {% series_list %}
#
# For futher information please visit: http://realjenius.com/2012/11/04/jekyll-series-list-2/
#
# Author: R.J. Lorimer
# Source: https://github.com/realjenius/site-samples/blob/master/2012-11-04-jekyll-series-list-2/series_tag.rb

module Jekyll
  
  class SeriesTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
      super
    end

    def render(context)
      site = context.registers[:site]
      page_data = context.environments.first["page"]
      series_name = page_data['series']
      if !series_name
        puts "Unable to find series name for page: #{page.title}"
        return "<!-- Error with series tag -->"
      end

      all_entries = []
      site.posts.each do |p|
        if p.data['series'] == series_name
          all_entries << p
        end
      end

      all_entries.sort_by { |p| p.date.to_f }

      text = "<div class='series_list'>"
      list = "<ol>"
      all_entries.each_with_index do |post, idx|
        list += "<li>"
        if post.data['title'] == page_data['title']
          list += "#{post.data['title']}"
          text += "<h4>#{post.data['series'][0]}</h4>"
        else
          list += "<a href='#{post.url}'>#{post.data['title']}</a>"
        end
        list += "</li>"
      end
      text += list += "</ol></div>"
      
    end
  end
end

Liquid::Template.register_tag('series_list', Jekyll::SeriesTag)