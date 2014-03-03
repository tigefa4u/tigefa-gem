module Tigefa
  module Tags
    class PostComparer
      MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)$/

      attr_accessor :date, :slug

      def initialize(name)
        all, path, date, slug = *name.sub(/^\//, "").match(MATCHER)
        @slug = path ? path + slug : slug
        @date = Time.parse(date)
      end

      def ==(other)
        slug == post_slug(other) &&
          date.year  == other.date.year &&
          date.month == other.date.month &&
          date.day   == other.date.day
      end

      private
      # Construct the directory-aware post slug for a Tigefa::Post
      #
      # other - the Tigefa::Post
      #
      # Returns the post slug with the subdirectory (relative to _posts)
      def post_slug(other)
        path = other.name.split("/")[0...-1].join("/")
        if path.nil? || path == ""
          other.slug
        else
          path + '/' + other.slug
        end
      end
    end

    class PostUrl < Liquid::Tag
      def initialize(tag_name, post, tokens)
        super
        @orig_post = post.strip
        @post = PostComparer.new(@orig_post)
      end

      def render(context)
        site = context.registers[:site]

        site.posts.each do |p|
          if @post == p
            return p.url
          end
        end

        puts "ERROR: post_url: \"#{@orig_post}\" could not be found"

        return "#"
      end
    end
  end
end

Liquid::Template.register_tag('post_url', Tigefa::Tags::PostUrl)
