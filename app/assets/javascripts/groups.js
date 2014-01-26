$(document).ready(function() {
	setEventHandler();
});

// イベントハンドラー
function setEventHandler() {
  $('.open').click(function() {
  	modalOpen();
  });
}

// モーダルオープン
function modalOpen() {
  $('#modal').dialog({
      modal: true,
      title: 'UpLoad!!'
  });
}