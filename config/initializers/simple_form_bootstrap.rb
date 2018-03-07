  # Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'col-xs-12 col-sm-3' do |ba|
      ba.use :label, class: 'control-label'
    end
    b.wrapper tag: 'div', class: 'col-xs-12 col-sm-9' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: {tag: 'span', class: 'help-block'}
      ba.use :hint,  wrap_with: {tag: 'span', class: 'help-block has-error'}
    end
  end

  config.wrappers :input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'col-xs-12 col-sm-3' do |ba|
      ba.use :label, class: 'control-label'
    end
    b.wrapper tag: 'div', class: 'col-xs-12 col-sm-9' do |ba|
      ba.wrapper tag: 'div', class: 'input-group' do |ig|
        ig.use :input, class: 'form-control'
      end
      ba.use :error, wrap_with: {tag: 'span', class: 'help-block'}
      ba.use :hint,  wrap_with: {tag: 'span', class: 'help-block has-error'}
    end
  end

  config.wrappers :login, tag: 'div', class: 'form-group', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'col-xs-12' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: {tag: 'span', class: 'help-block'}
      ba.use :hint,  wrap_with: {tag: 'span', class: 'help-block has-danger'}
    end
  end

  config.wrappers :signup, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label', wrap_with: { class: 'col-xs-12 col-sm-3' }
    b.wrapper tag: 'div', class: 'col-xs-12 col-sm-9' do |ba|
      ba.use :input, class: 'form-control'
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end

  config.wrappers :vertical, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input, class: 'form-control'
    b.use :error, wrap_with: {tag: 'span', class: 'help-block'}
    b.use :hint,  wrap_with: {tag: 'span', class: 'help-block has-error'}
  end

  config.wrappers :horizontal_input_group, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label', wrap_with: { class: 'col-xs-12 col-sm-3' }

    b.wrapper tag: 'div', class: 'col-xs-12 col-sm-9' do |ba|
      ba.wrapper tag: 'div', class: 'input-group col-xs-12' do |append|
        append.use :input, class: 'form-control'
      end
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  config.wrappers :bootstrap_file, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: 'control-label', wrap_with: { class: 'col-xs-12 col-sm-3' }
    b.wrapper tag: 'div', class: 'col-xs-12 col-sm-9' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap
end
