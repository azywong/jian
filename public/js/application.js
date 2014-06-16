$(document).ready(function() {
  $('.tag a').on('click', addTag)
});

var addTag = function(event){
  event.preventDefault();
  $.ajax({
    url: $(this).attr('href'),
    type: 'POST'
  })
  .done(function(severData){
    $(event.target).css('background-color', '#FF9B73')
  })
}