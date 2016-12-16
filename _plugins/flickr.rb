# Flickr Photoset Tag
#
# A Jekyll plug-in for embedding Flickr photoset in your Liquid templates.
#
# Usage:
#
#   {% flickr_photoset 72157624158475427 %}
#   {% flickr_photoset 72157624158475427 "Square" "Medium 640" "Large" "Site MP4" %}
#
# For futher information please visit: https://github.com/j0k3r/jekyll-flickr-photoset
#
# Author: Jeremy Benoist
# Source: https://github.com/j0k3r/jekyll-flickr-photoset

require 'flickraw'
require 'shellwords'

module Jekyll

  class FlickrPhotosetTag < Liquid::Tag
    include Jekyll::LiquidExtensions

    def initialize(tag_name, markup, tokens)
      super
      params = Shellwords.shellwords markup

      @photoset       = params[0]
      @class          = params[1] || "gallery"
      @photoThumbnail = params[2] || "Large Square"
      @photoEmbeded   = params[3] || "Medium 800"
      @photoOpened    = params[4] || "Large"
      @video          = params[5] || "Site MP4"
    end

    def render(context)
      # hack to convert a variable into an actual flickr set id
        if @photoset =~ /([\w]+\.[\w]+)/i
            @photoset = Liquid::Template.parse('{{ '+@photoset+' }}').render context
        end

      flickrConfig = context.registers[:site].config["flickr"]

      if cache_dir = flickrConfig['cache_dir']
        if !Dir.exist?(cache_dir)
          Dir.mkdir(cache_dir, 0777)
        end

        path = File.join(cache_dir, "#{@photoset}.yml")
        if File.exist?(path)
          photos = YAML::load(File.read(path))
        else
          photos = generate_photo_data(@photoset, flickrConfig)
          File.open(path, 'w') {|f| f.print(YAML::dump(photos)) }
        end
      else
        photos = generate_photo_data(@photoset, flickrConfig)
      end

      if photos.count == 1
        if photos[0]['urlVideo'] != ''
          output = "<p style=\"text-align: center;\">\n"
          output += "  <video controls poster=\"#{photos[0]['urlEmbeded']}\">\n"
          output += "    <source src=\"#{photos[0]['urlVideo']}\" type=\"video/mp4\" />\n"
          output += "  </video>\n"
          output += "  <br/><span class=\"alt-flickr\"><a href=\"#{photos[0]['urlFlickr']}\" target=\"_blank\">Voir la video en grand</a></span>\n"
          output += "</p>\n"
        else
          output = "<p style=\"text-align: center;\"><img class=\"th\" src=\"#{photos[0]['urlEmbeded']}\" title=\"#{photos[0]['title']}\" longdesc=\"#{photos[0]['title']}\" alt=\"#{photos[0]['title']}\" /></p>\n"
        end
      else
        output = "<div class='flickr #{@class}'>\n"

        if @class == 'summary' and photos.length > 8
          photos.first(8).each do |photo|
            output += "<span>\n"
            output += "<a title=\"#{photo['title']}\" href=\"#{photo['urlOpened']}\" class=\"image\"><img src='#{photo['urlThumb']}' alt=\"#{photo['title']}\" /></a>\n"
            output += "<a title='View on Flickr' href='#{photo['urlPhoto']}' class='flickrlink'> </a>\n"
            output += "</span>\n"
          end
        elsif @class == 'thumb'
          photos.sample(1).each do |photo|
            output += "<span>\n"
            output += "<a title=\"#{photo['title']}\" href=\"#{photo['urlOpened']}\" class=\"image\"><img src='#{photo['urlThumb']}' alt=\"#{photo['title']}\" /></a>\n"
            output += "<a title='View on Flickr' href='#{photo['urlPhoto']}' class='flickrlink'> </a>\n"
            output += "</span>\n"
          end
        else
          photos.each do |photo|
            output += "<span>\n"
            output += "<a title=\"#{photo['title']}\" href=\"#{photo['urlOpened']}\" class=\"image\"><img src='#{photo['urlThumb']}' alt=\"#{photo['title']}\" /></a>\n"
            output += "<a title='View on Flickr' href='#{photo['urlPhoto']}' class='flickrlink'> </a>\n"
            output += "</span>\n"
          end
        end

output += "</div>\n"
      end

      # return content
      output
    end

    def generate_photo_data(photoset, flickrConfig)
      returnSet = Array.new

      FlickRaw.api_key = ENV['FLICKR_API_KEY'] || flickrConfig['api_key']
      FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET'] || flickrConfig['shared_secret']
      flickr.access_token = ENV['FLICKR_ACCESS_TOKEN'] || flickrConfig['access_token']
      flickr.access_secret = ENV['FLICKR_ACCESS_SECRET'] || flickrConfig['access_secret']

      begin
        flickr.test.login
      rescue Exception => e
        raise "Unable to login, please check documentation for correctly configuring Environment Variables, or _config.yaml."
      end

      begin
        photos = flickr.photosets.getPhotos :photoset_id => photoset
      rescue Exception => e
        raise "Bad photoset: #{photoset}"
      end

      photos.photo.each_index do | i |

        title = photos.photo[i].title
        id    = photos.photo[i].id

        urlThumb   = String.new
        urlEmbeded = String.new
        urlOpened  = String.new
        urlVideo   = String.new
        urlPhoto   = String.new

        sizes = flickr.photos.getSizes(:photo_id => id)
        info = flickr.photos.getInfo(:photo_id => id)

        urlThumb       = sizes.find {|s| s.label == @photoThumbnail }
        urlEmbeded     = sizes.find {|s| s.label == @photoEmbeded }
        urlOpened      = sizes.find {|s| s.label == @photoOpened }
        urlVideo       = sizes.find {|s| s.label == @video }
        urlPhoto       = info.urls.find {|i| i.type == 'photopage' }

        photo = {
          'title' => title,
          'urlThumb' => urlThumb ? urlThumb.source : '',
          'urlEmbeded' => urlEmbeded ? urlEmbeded.source : '',
          'urlOpened' => urlOpened ? urlOpened.source : '',
          'urlVideo' => urlVideo ? urlVideo.source : '',
          'urlFlickr' => urlVideo ? urlVideo.url : '',
          'urlPhoto' => urlPhoto ? urlPhoto._content : '',
        }

        returnSet.push photo
      end

      # sleep a little so that you don't get in trouble for bombarding the Flickr servers
      sleep 1

      returnSet
    end
    output = nil
    returnSet = nil
  end

end

Liquid::Template.register_tag('flickr_photoset', Jekyll::FlickrPhotosetTag)

 
 

# module Jekyll
    
#     def self.flickr_setup(site)
#         # defaults
#         if !site.config['flickr']['cache_dir']
#             site.config['flickr']['cache_dir'] = '_flickr'
#         end
#         if !site.config['flickr']['size_full']
#             site.config['flickr']['size_full'] = 'Large'
#         end
#         if !site.config['flickr']['size_thumb']
#             site.config['flickr']['size_thumb'] = 'Large Square'
#         end

#         if not site.config['flickr']['use_cache']
#             # clear any existing cache
#             cache_dir = site.config['flickr']['cache_dir']

#             if Dir.exists?(cache_dir)
#                 FileUtils.rm_rf(cache_dir)
#             end
#             if !Dir.exists?(cache_dir)
#                 Dir.mkdir(cache_dir)
#             end

#             # populate cache from Flickr
#             FlickRaw.api_key = site.config['flickr']['api_key']
#             FlickRaw.shared_secret = site.config['flickr']['api_secret']

#             nsid = flickr.people.findByUsername(:username => site.config['flickr']['screen_name']).id
#             flickr_photosets = flickr.photosets.getList(:user_id => nsid)

#             flickr_photosets.each do |flickr_photoset|
#                 photoset = Photoset.new(site, flickr_photoset)
#             end
#         end
#     end

#     class Photoset
#         attr_accessor :id, :title, :slug, :cache_dir, :cache_file, :photos
        
#         def initialize(site, photoset)
#             self.photos = Array.new
#             if photoset.is_a? String
#                 self.cache_load(site, photoset)
#             else
#                 self.flickr_load(site, photoset)
#             end
#             self.photos.sort! {|left, right| left.position <=> right.position}
#         end
        
#         def flickr_load(site, flickr_photoset)
#             self.id = flickr_photoset.id
#             self.title = flickr_photoset.title
#             self.slug = self.title.downcase.gsub(/ /, '-').gsub(/[^a-z\-]/, '')
#             self.cache_dir = File.join(site.config['flickr']['cache_dir'], self.slug)
#             self.cache_file = File.join(site.config['flickr']['cache_dir'], "#{self.slug}.yml")
            
#             # write to cache
#             self.cache_store
            
#             # create cache directory
#             if !Dir.exists?(self.cache_dir)
#                 Dir.mkdir(self.cache_dir)
#             end
            
#             # photos
#             flickr_photos = flickr.photosets.getPhotos(:photoset_id => self.id).photo
#             flickr_photos.each_with_index do |flickr_photo, pos|
#                 self.photos << Photo.new(site, self, flickr_photo, pos)
#             end
#         end
        
#         def cache_load(site, file)
#             cached = YAML::load(File.read(file))
#             self.id = cached['id']
#             self.title = cached['title']
#             self.slug = cached['slug']
#             self.cache_dir = cached['cache_dir']
#             self.cache_file = cached['cache_file']
            
#             file_photos = Dir.glob(File.join(self.cache_dir, '*.yml'))
#             file_photos.each_with_index do |file_photo, pos|
#                 self.photos << Photo.new(site, self, file_photo, pos)
#             end
#         end
        
#         def cache_store
#             cached = Hash.new
#             cached['id'] = self.id
#             cached['title'] = self.title
#             cached['slug'] = self.slug
#             cached['cache_dir'] = self.cache_dir
#             cached['cache_file'] = self.cache_file
            
#             File.open(self.cache_file, 'w') {|f| f.print(YAML::dump(cached))}
#         end
        
#         def gen_html
#             content = ''
#             self.photos.each do |photo|
#                 content += photo.gen_thumb_html
#             end
#             return content
#         end
#     end

#     class Photo
#         attr_accessor :id, :title, :slug, :date, :description, :tags, :url_full, :url_thumb, :cache_file, :position
        
#         def initialize(site, photoset, photo, pos)
#             if photo.is_a? String
#                 self.cache_load(photo)
#             else
#                 self.flickr_load(site, photoset, photo, pos)
#             end
#         end
        
#         def flickr_load(site, photoset, flickr_photo, pos)
#             # init
#             self.id = flickr_photo.id
#             self.title = flickr_photo.title
#             self.slug = self.title.downcase.gsub(/ /, '-').gsub(/[^a-z\-]/, '') + '-' + self.id
#             self.date = ''
#             self.description = ''
#             self.tags = Array.new
#             self.url_full = ''
#             self.url_thumb = ''
#             self.cache_file = File.join(photoset.cache_dir, "#{self.id}.yml")
#             self.position = pos
            
#             # sizes request
#             flickr_sizes = flickr.photos.getSizes(:photo_id => self.id)
#             if flickr_sizes
#                 size_full = flickr_sizes.find {|s| s.label == site.config['flickr']['size_full']}
#                 if size_full
#                     self.url_full = size_full.source
#                 end
                
#                 size_thumb = flickr_sizes.find {|s| s.label == site.config['flickr']['size_thumb']}
#                 if size_thumb
#                     self.url_thumb = size_thumb.source
#                 end
#             end
            
#             # other info request
#             flickr_info = flickr.photos.getInfo(:photo_id => self.id)
#             if flickr_info
#                 self.date = DateTime.strptime(flickr_info.dates.posted, '%s').to_s
#                 self.description = flickr_info.description
#                 flickr_info.tags.each do |tag|
#                     self.tags << tag.raw
#                 end
#             end
            
#             cache_store
#         end
        
#         def cache_load(file)
#             cached = YAML::load(File.read(file))
#             self.id = cached['id']
#             self.title = cached['title']
#             self.slug = cached['slug']
#             self.date = cached['date']
#             self.description = cached['description']
#             self.tags = cached['tags']
#             self.url_full = cached['url_full']
#             self.url_thumb = cached['url_thumb']
#             self.cache_file = cached['cache_file']
#             self.position = cached['position']
#         end
        
#         def cache_store
#             cached = Hash.new
#             cached['id'] = self.id
#             cached['title'] = self.title
#             cached['slug'] = self.slug
#             cached['date'] = self.date
#             cached['description'] = self.description
#             cached['tags'] = self.tags
#             cached['url_full'] = self.url_full
#             cached['url_thumb'] = self.url_thumb
#             cached['cache_file'] = self.cache_file
#             cached['position'] = self.position
            
#             File.open(self.cache_file, 'w') {|f| f.print(YAML::dump(cached))}
#         end
        
#         def gen_thumb_html
#             content = ''
#             if self.url_full and self.url_thumb
#                 content = "<a href=\"#{self.url_full}\" data-lightbox=\"photoset\"><img src=\"#{self.url_thumb}\" alt=\"#{self.title}\" title=\"#{self.title}\" class=\"photo thumbnail\" width=\"75\" height=\"75\" /></a>\n"
#             end
#             return content
#         end
        
#         def gen_full_html
#             content = ''
#             if self.url_full and self.url_thumb
#                 content = "<p><a href=\"#{self.url_full}\" data-lightbox=\"photoset\"><img src=\"#{self.url_full}\" alt=\"#{self.title}\" title=\"#{self.title}\" class=\"photo full\" /></a></p>\n<p>#{self.description}</p>\n"
#                 if self.tags
#                     content += "<p>Tagged <i>" + self.tags.join(", ") + ".</i></p>\n"
#                 end
#             end
#             return content
#         end
#     end

#     # class PhotoPost < Post
#     #     def initialize(site, base, dir, photo)
#     #         name = photo.date[0..9] + '-photo-' + photo.slug + '.md'

#     #         data = Hash.new
#     #         data['title'] = photo.title
#     #         data['shorttitle'] = photo.title
#     #         data['description'] = photo.description
#     #         data['date'] = photo.date
#     #         data['slug'] = photo.slug
#     #         data['permalink'] = File.join('/archives', photo.slug, 'index.html')
#     #         data['flickr'] = Hash.new
#     #         data['flickr']['id'] = photo.id
#     #         data['flickr']['url_full'] = photo.url_full
#     #         data['flickr']['url_thumb'] = photo.url_thumb
            
#     #         if site.config['flickr']['generate_frontmatter']
#     #             site.config['flickr']['generate_frontmatter'].each do |key, value|
#     #                 data[key] = value
#     #             end
#     #         end
            
#     #         File.open(File.join('_posts', name), 'w') {|f|
#     #             f.print(YAML::dump(data))
#     #             f.print("---\n\n")
#     #             f.print(photo.gen_full_html)
#     #         }

#     #         super(site, base, dir, name)
#     #     end
#     # end

#     class FlickrPageGenerator < Generator
#         safe true
        
#         def generate(site)
#             Jekyll::flickr_setup(site)
#             cache_dir = site.config['flickr']['cache_dir']
            
#             file_photosets = Dir.glob(File.join(cache_dir, '*.yml'))
#             file_photosets.each_with_index do |file_photoset, pos|
#                 photoset = Photoset.new(site, file_photoset)
#                 if site.config['flickr']['generate_photosets'].include? photoset.title
#                     # generate photo pages if requested
#                     if site.config['flickr']['generate_posts']
#                         file_photos = Dir.glob(File.join(photoset.cache_dir, '*.yml'))
#                         file_photos.each do |file_photo, pos|
#                             photo = Photo.new(site, photoset, file_photo, pos)
#                             page_photo = PhotoPost.new(site, site.source, '', photo)

#                             # posts need to be in a _posts directory, but this means Jekyll has already
#                             # read in photo posts from any previous run... so for each photo, update
#                             # its associated post if it already exists, otherwise create a new post
#                             site.posts.each_with_index do |post, pos|
#                                 if post.data['slug'] == photo.slug
#                                     site.posts.delete_at(pos)
#                                 end
#                             end
#                             site.posts << page_photo
#                         end
#                     end
#                 end
#             end
            
#             # re-sort posts by date
#             site.posts.sort! {|left, right| left.date <=> right.date}
#         end
#     end

#     class FlickrPhotosetTag < Liquid::Tag
#         def initialize(tag_name, markup, tokens)
#             super
#             params = Shellwords.shellwords markup
#             title = params[0]
#             @slug = title.downcase.gsub(/ /, '-').gsub(/[^a-z\-]/, '')
#         end
        
#         def render(context)
#             site = context.registers[:site]
#             Jekyll::flickr_setup(site)
#             file_photoset = File.join(site.config['flickr']['cache_dir'], "#{@slug}.yml")
#             photoset = Photoset.new(site, file_photoset)
#             return photoset.gen_html
#         end
#     end

# end

# Liquid::Template.register_tag('flickr_photoset', Jekyll::FlickrPhotosetTag)




# Flickr Image Tag
#
# A Jekyll plug-in for embedding Flickr images in your Liquid templates.
#
# Usage:
#
#   A big image:
# 
#     {% flickr_image 6829790399 b %}
#
#   A medium-sized image:
#
#     {% flickr_image 7614906062 m %}
#
#   The same image, as a small square thumbnail:
#
#     {% flickr_image 7614906062 sq %}
#
# Author: Daniel Reszka
# Source: https://gist.github.com/danielres/3156265/

#require 'flickraw'
module Jekyll

  class FlickrImageTag < Liquid::Tag
 
    def initialize(tag_name, markup, tokens)
       super
       params = Shellwords.shellwords markup
      
       @id      = params[0]
       @classes = params[1] || "alignleft"
       @size    = params[2] || "q"
    end
   
    def render(context)
      
      # hack to convert a variable into an actual flickr set id
      if @id =~ /([\w]+\.[\w]+)/i
        @id = Liquid::Template.parse('{{ '+@id+' }}').render context
      end
   
      flickrConfig = context.registers[:site].config["flickr"]
      FlickRaw.api_key        = flickrConfig['api_key']
      FlickRaw.shared_secret  = flickrConfig['shared_secret']
      flickr.access_token     = flickrConfig['access_token']
      flickr.access_secret    = flickrConfig['access_secret']
   
      info = flickr.photos.getInfo(:photo_id => @id)
   
      server        = info['server']
      farm          = info['farm']
      id            = info['id']
      secret        = info['secret']
      title         = info['title']
      description   = info['description']
      size          = "_#{@size}" if @size
      classes       = "#{@classes}" if @classes
      src           = "http://farm#{farm}.static.flickr.com/#{server}/#{id}_#{secret}#{size}.jpg"
      full          = "http://farm#{farm}.static.flickr.com/#{server}/#{id}_#{secret}_b.jpg"
      page_url      = info['urls'][0]["_content"]
   
      img_tag       = "<img src='#{src}' alt=\"#{title}\" />"
      if @classes == 'thumb'
        link_tag    = img_tag
      else
        link_tag      = "<div class='flickr image #{classes}'>"
        link_tag     += "<span>"
        link_tag     += "<a title=\"#{title}\" href='#{full}' class=\"image\">#{img_tag}</a>"
        link_tag     += "<a title='View on Flickr' href='#{page_url}' class='flickrlink'> </a>"
        link_tag     += "</span>"
        link_tag     += "</div>"
      end    
    end
  end
end
 
Liquid::Template.register_tag('flickr_image', Jekyll::FlickrImageTag)