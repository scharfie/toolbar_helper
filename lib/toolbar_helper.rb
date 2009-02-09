module ToolbarHelper
  # Returns a collectible for toolbars
  def toolbar_collection
    @toolbar_collection ||= Slate::Collectible.new(:toolbar)
  end
  
  def with_toolbar(key, &block)
    toolbar_collection.keys.push(key)
    yield
    toolbar_collection.keys.pop
  end
  
  def clear_toolbar!(key=nil)
    toolbar_collection.items(key).clear
  end
  
  # Creates a new collectible item
  def toolbar_item(key=nil, content=nil, &block)
    # capture(&block) if block_given?
    # (content ||= '') << capture(&block) if block_given?
    with_output_buffer do
      toolbar_collection.push(key, content, &block)
    end  
  end
  
  # Creates a link_to with given arguments for current
  # toolbar
  def toolbar_link(*args)
    toolbar_item link_to(*args)
  end
  
  # Renders collectible
  def toolbar(*args)
    options = Hash === args.last ? args.pop : {}
        key = args.first unless Hash === args.first
    
    items = toolbar_collection.items(key).reject(&:blank?)

    options.reverse_merge!({ 
      :separator => '|', 
      :separator_options => { :class => 'separator' },
      :class => 'toolbar'
    })

    separator = options.delete(:separator)
    separator_options = options.delete(:separator_options)

    unless items.empty?
      separator = content_tag('li', separator, separator_options)
      list_items = items.map { |e| content_tag('li', e) }.join(separator)
      content_tag('ul', list_items, options)
    end
  end
end