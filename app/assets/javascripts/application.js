// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
$(document).ready(function(){
  // $('.cell').toggle(
  //   function(){$(this).css({"background-color":"green"});},
  //   function(){$(this).css({"background-color":"red"});}
  // });
  $('.cell').on('click', function(){
    var tens = ($(this).parent().index())
    var ones = ($(this).index())
    var id = (tens*10) + ones
    var board_id = $('.whole-board').attr('id').replace(/\D+/, '')

    if ($(this).hasClass('wall')){ // 2, starting point
      $(this).removeClass('wall');
      $(this).addClass('maze-walker');
      var thing = 'maze-walker'
    } else if ($(this).hasClass('maze-walker')){ // 3, finish line
      $(this).removeClass('maze-walker');
      $(this).addClass('finish-line');
      var thing = 'finish-line'
    } else if ($(this).hasClass('finish-line')){ // 3, nothing "path"
      $(this).removeClass('finish-line');
      var thing = 'path'
    } else { // 1, wall
      $(this).addClass('wall');
      var thing = 'wall'
    };
    $.ajax({
      url: `/boards/${board_id}`,
      method: 'put',
      datatype: 'json',
      data: {number: id, type: thing}
    });
  })
});
