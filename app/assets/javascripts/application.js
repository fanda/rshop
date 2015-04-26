//= require jquery
//= require jquery_ujs
//= require jquery.tooltip
//= require jquery.textfill
//= require jquery.tools.scrollable
//= require facebox
//= require_self

jQuery(document).ready(function($) {
  $('a[rel*=facebox]').facebox({
    loading_image : 'loading.gif',
    close_image   : 'closelabel.gif'
  });

	$('.product-title').textfill({ maxFontPixels: 16 });
	$('.tfil').textfill({ maxFontPixels: 24 });

  $("#promo")
    .scrollable({circular: true, speed: 300})
    .navigator(".navi")
    .autoscroll({interval: 5000});

  $("td.amount").click(function() {
    if ($("td.amount input").length > 0) return;
    var former = $(this).text().replace(/\D/g, '');
    var input = $(document.createElement('input'));
    var cell = $(this);
    input.attr('value', former);
    input.addClass('amountInput');
    input.css('width', $(this).css('width'));
    input.blur(function(e) {
      var val = $(this).val().replace(/\D/g, '');
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
  $('#show_ia_form').click(function () {
    $('#ia_form').toggle(this.checked);
  });
  $('#order_payment_method_input label').click(function () {
    var v1 = $(this).text().match(/\d+/);
    var v2 = $('#sum').text().match(/\d+/);
    var rs = parseInt(v1) + parseInt(v2);
    $('#total span').text(rs);
    $('#total').show('slow');
  });
});
