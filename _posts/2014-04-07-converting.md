---
comments: true
date: 2014-04-07 19:32:31+00:00
layout: post
title: Converting the Posts
image: /assets/images/jekyll.png
tags:
- Technology
- Jekyll
series: 
- Migrating to Jekyll
---

> #### Update 15 June 2023
  _The Flickr Image and Flickr Photoset tags now seem to result in build errors so I have removed
  them from all posts and replaced with the previously generated HTML. I may try to make this cleaner
  at some point in the future, but no plans at the moment!_

The next step in the migration to [Jekyll][jk] was to export my existing blog posts from [WordPress][wp]
and then convert them into [Markdown][md] format so they can be used in the new blog. There are a
number of different options for doing this, including Jekyll's own migration option [Jekyll Import][ji]
Bearing in mind the purpose of the move was purely academic there was no need to rush this step so I
tried a number of different options to see which one worked best for me. In the end, I used a little
[Python][py] script written by [Thomas Frössman][tf] called [Exitwp][xp]. The Jekyll script was ok,
but it pulled some random data from the WP SEO plugin that I was using, and didn't properly convert
the existing posts to proper Markdown.

Once Exitwp had converted all my posts to Markdown, I had to go through and make amendments to each
file to ensure it was displayed correctly. This was not the fault of Exitwp, but my own personal
preferences. I have setup a number of posts to display a certain way, and to include things in a
specific position on the page so I had to make adjustments to suit this. For example, thumbnails in
my posts can be on the left or the right of the page, or a large image could be included in the
centre of the page. Jekyll's default Markdown engine doesn't support setting classes on different
elements so I chose the [Kramdown][kd] engine rather than using html. This meant I needed to make a
few alterations to make sure the posts rendered correctly when the site is generated.

As part of the migration process, I also decided that I wanted to move all my photo hosting to
[Flickr][fl], especially considering the 1TB of free file storage available there. So I set up a 
[collection][coll] on Flickr for all my blog photos and I then had to change the image links in all
my posts to match the new flickr image locations. To achieve this I used a couple of Jekyll plugins
for Liquid tags which meant I simply had to include `{% raw %}{% flickr_image 0000000 %}{% endraw %}`
in the markdown file to show an image with a link back to Flickr (_<small>as per the terms of my
Flickr account</small>_), or `{% raw %}{% flickr_photoset 0000000 %}{% endraw %}` to show a gallery
generated from a Flickr Photoset with the relevant links back to Flickr. 

### Flickr Image Tag Plugin

This is my modified version of the Flickr Image Tag Plugin written by [Daniel Reszka][dr].

<script src="https://gist.github.com/richardp2/10020777.js"></script>

### Flickr Photoset Tag Plugin

This is my modified version of the Flickr Photoset Tag Plugin written by [Jeremy Benoist][jb].

<script src="https://gist.github.com/richardp2/10020936.js"></script>


[jk]: //jekyllrb.com/ "Jekyll &bull; Simple, blog-aware, static sites"
[wp]: //wordpress.org/ "WordPress &#8250; Blog Tool, Publishing Platform, and CMS"
[md]: //daringfireball.net/projects/markdown/ "Markdown"
[ji]: //import.jekyllrb.com/ "Jekyll Import"
[py]: //python.org/ "Welcome to Python.org"
[tf]: //thomas.jossystem.se/ "Thomas Frössman"
[xp]: //github.com/thomasf/exitwp "Exitwp"
[kd]: //kramdown.gettalong.org/ "Kramdown"
[fl]: //flickr.com/ "Flickr"
[coll]: //flickr.com/photos/richard-perry/collections/72157641951146185/ "Blogs Collection"
[dr]: //gist.github.com/danielres/3156265/ "Flickr Image Tag Plugin by Daniel Reszka"
[jb]: //github.com/j0k3r/jekyll-flickr-photoset "Flickr Photoset Tag Plugin by Jeremy Benoist"