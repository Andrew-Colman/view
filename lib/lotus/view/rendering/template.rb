require 'lotus/view/rendering/template_finder'

module Lotus
  module View
    module Rendering
      # Rendering template
      #
      # It's used when a template wants to render another template.
      #
      # @api private
      # @since 0.1.0
      #
      # @see Lotus::View::Rendering::LayoutScope#render
      #
      # @example
      #   # We have an application template (templates/application.html.erb)
      #   # that uses the following line:
      #
      #   <%= render template: 'articles/show' %>
      class Template
        # Initialize a template
        #
        # @param view [Lotus::View] the current view
        # @param options [Hash] the rendering informations
        # @option options [Symbol] :format the current format
        # @option options [Hash] :locals the set of objects available within
        #   the rendering context
        #
        # @api private
        # @since 0.1.0
        def initialize(view, options)
          @view, @options = view, options
        end

        # Render the template.
        #
        # @return [String] the output of the rendering process.
        #
        # @api private
        # @since 0.1.0
        def render
          found_template = template
          raise_missing_template_error if found_template.nil?
          found_template.render(scope)
        end

        protected
        def template
          TemplateFinder.new(@view.class, @options).find
        end

        def scope
          Scope.new(@view, @options[:locals])
        end

        def raise_missing_template_error
          template_name = @options[:template] if @options.key?(:template)
          template_name = @options[:partial] if @options.key?(:partial)
          raise MissingTemplateError.new(template_name, @options[:format])
        end
      end
    end
  end
end
