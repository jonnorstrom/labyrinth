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
function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}

function movePlayer(direction) {
  console.log(direction);
  var $current = $('.whole-board').find('td.maze-walker');
  var $parent = $current.parent();
  var id = ($current.index());
  if (direction === "left") {
      $current.prev().addClass('maze-walker');
  } else if (direction === "right") {
      $current.next().addClass('maze-walker');
  } else if (direction === "up") {
      $parent.prev().find("td:eq("+id+")").addClass('maze-walker');
  } else {
      $parent.next().find("td:eq("+id+")").addClass('maze-walker');
  }
  $current.removeClass('maze-walker');
  sleep(500);
}

$(document).ready(function(){
  $('.cell').on('click', function(){
    var tens = ($(this).parent().index());
    var ones = ($(this).index());
    var id = (tens*10) + ones;
    var board_id = $('.whole-board').attr('id').replace(/\D+/, '');
    var thing;
    if ($(this).hasClass('wall')){ // 2, starting point
        $(this).removeClass('wall');
        $(this).addClass('maze-walker');
        thing = 'maze-walker';
    } else if ($(this).hasClass('maze-walker')){ // 3, finish line
        $(this).removeClass('maze-walker');
        $(this).addClass('finish-line');
        thing = 'finish-line';
    } else if ($(this).hasClass('finish-line')){ // 3, nothing "path"
        $(this).removeClass('finish-line');
        thing = 'path';
    } else { // 1, wall
        $(this).addClass('wall');
        thing = 'wall';
    }

    var request = $.ajax({
      url: `/boards/${board_id}`,
      method: 'put',
      datatype: 'json',
      data: {number: id, type: thing}
    });
  });

  $('form.run').on('submit', function(event){
    event.preventDefault();
    var board_id = $('.whole-board').attr('id').replace(/\D+/, '');
    var request = $.ajax({
      url: `/boards/${board_id}`
    });

    request.done(function(allMoves){
      // animate, one step at a time by iterating through response['moves'] array.
      allMoves.moves.pop();
      for (var i = 0; i < allMoves.moves.length; i++) {
        sleep(400);
        movePlayer(allMoves.moves[i]);
        // setTimeout(movePlayer(allMoves.moves[move]), 2000);
      }
    });
  });
});
