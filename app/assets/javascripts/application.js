// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require summernote/summernote-bs4.min
//= require summernote-init
//= require activestorage
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(document).on('turbolinks:load', function(){
	// デフォルトのRoomsセレクトボックスHTML
	let defaultRoomSelect = $(`#rooms-of-houses`).html()

	//最初から家が選択されている時の処理
	let houseVal = $('#memo_house_id').val();
	if (houseVal !== "") {
		let selectedTemplate = $(`#rooms-of-house${houseVal}`).html();
		$('#memo_house_id').after(selectedTemplate);
	}else{
		$('#memo_house_id').after(defaultRoomSelect);
	};


		//家が変更されてvalueに値が入った時の処理
	$(document).on('change', '#memo_house_id', function() {
		let houseVal = $('#memo_house_id').val();
		if (houseVal !== "") {
			let selectedTemplate = $(`#rooms-of-house${houseVal}`).html();
			$('#memo_room_id').remove();
			$('#memo_house_id').after(selectedTemplate);
		}else {
			$('#memo_room_id').remove();
			$('#memo_house_id').after(defaultRoomSelect);
  	};
	});
});
