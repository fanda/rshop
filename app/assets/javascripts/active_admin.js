//= require active_admin/base
//= require ckeditor/init

CKEDITOR.config.entities = false;
CKEDITOR.config.entities_latin = false;


jQuery(document).ready(function($) {
  clickableCosA();
});

function clickableCosA() {
  $('.cos a').click(function(event) {
    event.preventDefault();
    $.ajax({
      url: $(this).attr('href'),
      type: 'POST',
      data: { '_method': 'PUT' },
    });
  });
};
