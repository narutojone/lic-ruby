var currentEditor;

function insertAtCaret(input_id, text) {
  var text_input = document.getElementById(input_id);
  var scrollPos = text_input.scrollTop;
  var caretPos = text_input.selectionStart;

  var front = (text_input.value).substring(0, caretPos);
  var back  = (text_input.value).substring(text_input.selectionEnd, text_input.value.length);

  text_input.value = front + text + back;
  caretPos = caretPos + text.length;
  text_input.selectionStart = caretPos;
  text_input.selectionEnd = caretPos;
  text_input.focus();
  text_input.scrollTop = scrollPos;
}

$(document).on('change', '.js-email-notification-quick-toggle', function(event) {
  var $form = $(event.currentTarget).closest('form');
  $form.submit();
});

$(document).ready(function () {
  $('#show-placeholders-button').click(function(){
    $(this).siblings('#placeholder-list').slideToggle();
    return false;
  });

  $('.summernote').on('summernote.focus', function(e) {
    currentEditor =  $(this);
  });

  $('#placeholder-list input[type="button"]').mousedown(function(e) {
    e.preventDefault();

    var placeholder  = $(this).attr('data-placeholder');
    var $focused     = $(':focus');

    if ($focused.length > 0 && !$focused.hasClass('note-editable')) {
      insertAtCaret($focused.attr('id'), placeholder);
    } else if (!!currentEditor) {
      currentEditor.summernote('insertText', placeholder);
    }
  });
});
