module BreadcrumbsHelper
  def add_breadcrumb(name, path = nil)
    @breadcrumbs ||= []
    @breadcrumbs << { name: name, path: path }
  end

  def render_breadcrumbs
    return unless @breadcrumbs&.any?

    content_tag :nav, class: 'mb-4', "aria-label": 'パンくず' do
      content_tag :ol, class: 'flex items-center space-x-2 text-sm text-gray-600' do
        breadcrumb_items = @breadcrumbs.map.with_index do |breadcrumb, index|
          is_last = index == @breadcrumbs.length - 1

          content_tag :li, class: 'flex items-center' do
            content = if breadcrumb[:path] && !is_last
              link_to breadcrumb[:name], breadcrumb[:path], class: 'hover:text-blue-600 transition-colors'
            else
              content_tag :span, breadcrumb[:name], class: 'text-gray-900 font-medium'
            end

            separator = unless is_last
              content_tag :svg, class: 'w-4 h-4 mx-2 text-gray-400', fill: 'currentColor', viewBox: '0 0 20 20' do
                tag.path("fill-rule": 'evenodd', d: 'M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z', "clip-rule": 'evenodd')
              end
            end

            content + (separator || '').html_safe
          end
        end

        safe_join(breadcrumb_items)
      end
    end
  end
end
