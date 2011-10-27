//= require jquery
//= require jquery_ujs
//= require jquery.tooltip
//= require facebox
//= require_self
jQuery(document).ready(function($) {
  $('a[rel*=facebox]').facebox({
    loading_image : 'loading.gif',
    close_image   : 'closelabel.gif'
  });
  pimg();

  $("td.amount").click(function() {
    if ($("td.amount input").length > 0) return;
    var former = $(this).text().replace(/\D/g, '');
    var input = $(document.createElement('input'));
    var cell = $(this);
    input.attr('value', former);
    input.addClass('amountInput');
    input.css('width', $(this).css('width'));
    input.blur(function() {
      var val = $(this).attr('value').replace(/\D/g, '');
      if (val.length > 0)
      {
        cell.html(val +'ks');
        var id = cell.parent().attr('id').replace('p_','');
        $.ajax({
          url: '/cart/update/'+id+'?amount='+val,
          type: 'get',
          dataType: 'script',
          data: { '_method': 'get' },
          success: function() {}
        });
      }
      else
        cell.html(former +'ks');
    });
    $(this).html(input);
    jQuery("input", this).focus().select();
  });
