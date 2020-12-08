# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderSortableTreeFirmCatalogHelper
  module Render 
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]

        "
          <li data-node-id='#{ node.id }' id='node_#{h.dom_id(node)}'>
            <div class='item'>
              <i class='handle'></i>
              #{'<b class=\'expand plus\'>+</b>' if node.root? && node.children_count.to_i > 0}
              #{ show_link }
              #{ controls }
            </div>
            #{ children }
          </li>
        "
      end

      def show_link
        node = options[:node]
        "<div class='show'>#{ h.render node }</div>"
      end

      def controls
        node = options[:node]

        new_path =     h.url_for(controller: options[:klass].pluralize, action: :new,     parent_id: node.id)
        edit_path =    h.url_for(controller: options[:klass].pluralize, action: :edit,    id: node)
        destroy_path = h.url_for(controller: options[:klass].pluralize, action: :destroy, id: node)

        "
          <div class='controls'>
            #{ h.link_to '', new_path, class: :new, remote: true }
            #{ h.link_to '', edit_path, class: :edit, remote: true }
            #{ h.link_to '', destroy_path, class: :delete, remote: true, method: :delete, data: { confirm: 'Are you sure?' } }
          </div>
        "
      end

      def children
        unless options[:children].blank?
          "<ol class='nested_set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end
