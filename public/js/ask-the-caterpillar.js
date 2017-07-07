$(document).ready(function(){
  $('#loading').hide();

  $(function() {
  var $selector = $('#query');
  $(document.body).off('keyup', $selector);
  $(document.body).on('keyup', $selector, function(event) {
    if(event.keyCode == 13) { // 13 = Enter Key
      queryCaterpillar();
    }
  });
});

  $('#drug-info-button').click(function(){
    queryCaterpillar();
  });
});

function queryCaterpillar(){
  $('#caterpillar-answer').hide();
  var data = $("#query").val();
  $.ajax({
    type: "POST",
    url: '/query',
    data: { 'query': data },
    success: function (data) {
        var answer = data.data.messages[0].content
        $("#caterpillar-answer").show();
        $("#caterpillar-answer").html(answer);
    }
  });
};
