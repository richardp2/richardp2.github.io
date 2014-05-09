# Makes use of the Jekyll category page generator by Dave Perrett, http://recursive-design.com/.
# 
# Now only using the category links filter from Dave's original plugin so that I can have more 
# fine grained control of the category pages. Also made a few modifications to it to show the
# sub category links properly/the way I want them :-)
#

module Jekyll
  module Filters
        
    def category_dir(base_dir, category)
      base_dir = base_dir.gsub(/^\/*(.*)\/*$/, '\1')
      category = category.split
      category = category[0].gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase
      File.join(base_dir, category)
    end

    # Outputs a list of categories as comma-separated <a> links. This is used
    # to output the category list for each post on a category page.
    #
    #  +categories+ is the list of categories to format.
    #
    # Returns string
    def category_links(categories)
      base_dir = @context.registers[:site].config['category_dir']
      @categorydir = ''
      categories = categories.map do |category|
        base_dir = File.join(base_dir, @categorydir) unless @categorydir == ''
        @categorydir = self.category_dir(base_dir, category)
        # Make sure the category directory begins with a slash.
        @categorydir = "/#{@categorydir}" unless @categorydir =~ /^\//
          "<a class='category' href='#{@categorydir}/'>#{category.titlecase}</a>"
      end
      
      @categorydir = ''

      case categories.length
      when 0
        ""
      when 1
        categories[0].to_s
      else
        categories.join(', ')
      end
    end

  end

end