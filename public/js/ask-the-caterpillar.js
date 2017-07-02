$(document).ready(function(){
  var $loading = $('#loading').hide();
  
  $('#drug-info-button').click(function(){
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
    });
});
