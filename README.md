# Richard Perry

[![build status][bb]][bbl]

This (https://richard.perry-online.me.uk/) is the source code for my blog. The blog was created with
the sole purpose of giving me somewhere to write. After creating a blog for a travel exploits in
China (https://travel.perry-online.me.uk/), I decided that I quite enjoyed writing so I set this
blog up for non-travel based random thoughts and feelings etc.

## Background

The blog was originally created in 2011 and was a hosted [WordPress][] instance with a custom theme.
I used [WordPress][] because that was what I was using for the travel blog and so I knew how to use
it and I already had the custom theme set up to my liking. I cannot seem to leave things alone
though, so I made numerous alterations to the theme, continually tweaking (_and sometimes breaking_)
the site. At the beginning of 2014, I came across [Jekyll][] ("a simple, blog-aware, static site
generator") and I was intrigued by the concept.

At this point I started work on migrating all my personal sites (which now included a photography
portfolio site at https://photos.perry-online.me.uk/) to [Jekyll][] and also over to a new, free
hosting platform at [GitHub Pages][ghp]. Once the migration was complete, I was able to cancel my
hosting account and save myself some money. This new setup seemed to be really good because all my
coding projects were hosted on [Subversion][] or [Git][] repositories already so it was simple.
Unfortunately, plugins are restricted on [GitHub Pages][ghp] so I had to have two branches, one for
the source and one for the static site files and I had to build the site on my own machine.

> For more information about the migration process I followed see my [blog series][bs].

Having to keep a build environment setup for testing, building and deploying was a bit of a nuisance
for a simple blog so, in March 2015 I further updated the site so that it did not need any plugins
and [GitHub Pages][ghp] could build and deploy the site for me.

However, this did not last as I am an eternal tinkerer. In early 2016, I discovered that
[GitLab][gl] not only had an offering like [GitHub Pages][ghp], but because of the way it is setup
you can use whatever plugins and build scripts etc that you like! So, in April 2016 my travel blog
and photography portfolio sites were migrated over to [GitLab Pages][glp] for testing and I found
the solution to be flawless. Obviously this meant I had to make some changes to all the different
sites to reinclude the plugins that made my life easier in the first place, test them, tweak them
and generally get everything up and running properly, but once that was sorted, it was time to 
migrate over my main blog (_i.e. this one_) and the network home page
(https://www.perry-online.me.uk). This took a bit of time and I wasn't finished until early 2017,
but whilst I was doing all the work to update the sites etc, I felt it was a good time to give the
network a facelift and that was launched in February 2017.

Now, in theory, I should be able to get back to the task of writing :smiley:.

## Licenses

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">
<img alt="Creative Commons Licence" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" />
</a>
<br />This work by 
<a xmlns:cc="http://creativecommons.org/ns#" href="https://richard.perry-online.me.uk/" property="cc:attributionName" rel="cc:attributionURL">
Richard Perry
</a> 
is licensed under a 
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">
Creative Commons Attribution 4.0 International License
</a>.
This gives you permission to use the content for almost any purpose (but does not grant you any
trademark permissions), so long as you note the license and give credit, such as follows:

> Content based on richard.perry-online.me.uk/ used under the CC-BY-4.0 license.

When you contribute to this repository you are doing so under the above licenses.

[bbl]: https://gitlab.com/richardp2/richardp2.github.io/commits/pages "Build Status"
[bb]: https://gitlab.com/richardp2/richardp2.github.io/badges/pages/build.svg
[WordPress]: https://wordpress.org/ "WordPress &#8250; Blog Tool, Publishing Platform, and CMS"
[Jekyll]: https://jekyllrb.com/ "Jekyll &bull; Simple, blog-aware, static sites"
[gh]: https://github.com/ "GitHub"
[ghp]: https://pages.github.com/ "GitHub Pages"
[gl]: https://gitlab.com/ "GitLab"
[glp]: https://pages.gitlab.io "GitLab Pages"
[bs]: https://richard.perry-online.me.uk/series/jekyll/ "Series: Migrating to Jekyll | Richard Perry"
[bl]: https://richard.perry-online.me.uk/ "Richard Perry | Just another blog about nothing"
[Subversion]: https://subversion.apache.org/
[Git]: https://git-scm.com/