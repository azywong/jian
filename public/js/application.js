$(document).ready(function() {
  $('.tag a').on('click', addTag)
  $('.bubble table tr td input').on('click', deleteTag)
});

var addTag = function(event){
  event.preventDefault();
  $.ajax({
    url: $(this).attr('href'),
    type: 'POST'
  })
  .done(function(severData){
    $(event.target).attr('class', 'tagged')
  })
}

var deleteTag = function(event){
  event.preventDefault();
  $.ajax({
    url: $(event.target.parentElement).attr('action'),
    type: 'DELETE'
  })
  .done(function(severData){
    $(event.target.parentElement.parentElement.parentElement).css('display', 'none')
  })
}