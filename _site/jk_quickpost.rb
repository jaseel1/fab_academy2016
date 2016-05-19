#!/usr/bin/env ruby
# http://gist.github.com/133592
# author: Thomas Aylott (subtlegradient.com)
# license: MIT
# 
# usage:
#   jk_quickpost.rb title [categories [filetype]]
# 
# title is used as the title, description and slug
# categories can be a comma or space separated list. It'll try separating by commas first and then spaces if commas didn't work.
# filetype is any filetype that jekyll supports. md, markdown, textile, html, etc..
# 
# example: 
#   jk_quickpost.rb "Hello world!" "my, blog post, of, doom" "textile"

def escape_slug(string)
  string.gsub(/[^\w]/,'_').gsub(/^_+|_+$/,'').downcase
end

require 'date'
require 'yaml'

abort "Needs a title" unless ARGV.first

@ROOT       = '/users/taylott/Projects/subtleGradient/subtlegradient.com/private/_posts'

@title      = ARGV.shift
@categories = ARGV.shift.split(/,\s*/)
@categories = @categories.first.split(/\s+/) unless @categories.length > 1
@kind       = ARGV.shift || 'md'

@slug       = escape_slug(@title)
@filename   = "#{Date.today}-#@slug.#@kind"
@path       = "#@ROOT/#@filename"

@header   = {
  "layout"      => 'post',
  "title"       => @title,
  "description" => @title,
  "keywords"    => @categories.join(', '),
  "categories"  => @categories
}
unless File.exists? @path
  
  File.open(@path, 'w') do |file|
    file.write @header.to_yaml.sub(/\n+\Z/,"\n")
    file.write "---\n\n"
  end
  
end

puts `cd #@ROOT  &&\\\n  mate -w #@filename  &&\\\n  git add #@filename  &&\\\n  git ci -v  &&\\\n  git push origin master  &&\\\n  git push stage master`

