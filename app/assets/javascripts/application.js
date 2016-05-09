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

function movePlayer(y, x) {
  var $current = $('.whole-board').find('td.maze-walker');
  // console.log($current)
  // $current.removeClass('maze-walker');
  $current.toggleClass('maze-walker');
  // var id counts ALL td's as one big list, from 0-99. Finds the exact one (eg. 65)
  var id = ((y*10) + x);
  // var $cell takes the id value and finds the correct 'td', and then adds the little man to it.
  var $cell = $('.whole-board').find("td:eq("+id+")").toggleClass('maze-walker');
  // console.log($current)
  // console.log(rowIndex)
  // console.log(whichRow)
  // console.log($cell)
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
    } else if ($(this).hasClass('finish-line')){ // 4, nothing "path"
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
      // animate, one step at a time by iterating through allMoves['moves'] array.


      // trying to force the animation to happen one instance at a time, still didn't work
      // allMoves.moves.pop();
      // movePlayer(allMoves.moves[0]["y"], allMoves.moves[0]["x"]);
      // sleep(500);
      // movePlayer(allMoves.moves[1]["y"], allMoves.moves[1]["x"]);
      // sleep(500);
      // movePlayer(allMoves.moves[2]["y"], allMoves.moves[2]["x"]);
      // allMoves.moves.pop();
      // var i = 0;
      // $(document).on('click', function(){
      //   movePlayer(allMoves.moves[i]["y"], allMoves.moves[i]["x"]);
      //   i += 1;
      // });
      // What I believe should be working. both the movePlayer and sleep methods are defined at the top of the page
      allMoves.moves.pop(); // removes last move so that he stops before the finish line
      for (var i = 0; i < allMoves.moves.length; i++) {
        movePlayer(allMoves.moves[i]["y"], allMoves.moves[i]["x"]);
        sleep(400); // sleep for 400ms
      }
    });
  });
});
