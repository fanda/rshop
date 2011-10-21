jQuery(document).ready(function($) {
  $('tbody#products').tableDnD({
    onDrop: function(table, row) {
      $.ajax({
        type: "POST",
        url: "/manage/catalog/product/sort",
        processData: false,
        data: $.tableDnD.serialize(),
        success: function(msg) {}
      });
    }
   });
  $('tbody#categories').tableDnD({
    onDrop: function(table, row) {
      $.ajax({
        type: "POST",
        url: "/manage/catalog/category/sort",
        processData: false,
        data: $.tableDnD.serialize(),
        success: function(msg) {}
      });
    }
   });

  $("td.note").click(function() {
    var input = $(this).find("textarea")
    var id = input.attr('id').replace('note_','');
    input.blur(function() {
      $.post('/manage/orders/note/'+id,
        { note: input.val() },
        function(res) {
          input = $("#note_"+id);
          input.css('border', 'green');
        }
      );
    });
  });

  $(".state-box").change(function() {
    var id = $(this).attr('id').replace('state_','');
    $.post('/manage/orders/state/'+id,
      { state: $(this).val() },
      function(res) {$(this).css('border', 'green');}
    );
  });

});
