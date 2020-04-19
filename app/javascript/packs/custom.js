$(document).ready(function() {
  $('form > input').keyup(function() {
    var empty = false;
    $('.field input').each(function() {
      if ($(this).val().length == 0) {
	empty = true;
      }
    });

    if (empty) {
      $('.actions').attr('disabled', 'disabled');
    } else {
      $('.actions').attr('disabled', false);
    }
  });
});
