# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.label_text = lambda { |label, required| "#{label}" }

  config.wrappers :bootstrap, :tag => 'div', :class => 'cntrl-group', :error_class => 'error' do |b|
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'cntrls' do |ba|
      ba.use :input
      ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end

  config.wrappers :prepend, :tag => 'div', :class => "cntrl-group", :error_class => 'error' do |b|
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'cntrls' do |input|
      input.wrapper :tag => 'div', :class => 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    end
  end

  config.wrappers :append, :tag => 'div', :class => "cntrl-group", :error_class => 'error' do |b|
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div', :class => 'cntrls' do |input|
      input.wrapper :tag => 'div', :class => 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    end
  end

  config.wrappers :none do |b|
    b.use :placeholder
    b.use :label
    b.wrapper :tag => 'div' do |input|
      input.use :input
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
      input.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
    end
  end

  config.wrappers :checkbox, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :placeholder
    b.wrapper :tag => 'div', :class => 'controls' do |input|
      input.wrapper :tag => 'div', :class => 'simple-checkbox' do |prepend|
        prepend.use :label_input
      end
      input.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
      input.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
    end
  end

  config.wrapper_mappings = { :boolean => :checkbox }
  config.boolean_style = :nested

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
