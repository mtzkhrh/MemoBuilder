$(document).on('turbolinks:load', function(){
	// 画面リロードでの重複を避ける
	let defaultRoomSelect = $(`#rooms-of-houses`).html();
	$('#memo_room_id').remove();
	$('#memo_house_id').after(defaultRoomSelect);
	// メモの部屋に合わせて家を選択する
	let roomVal = $('#memo_room_id').val();
	if ( roomVal !== "") {
		let houseId = $(`.default-rooms`).find('option:selected').data("houseId");
		$('#memo_house_id').val(houseId);
	}
	// 全部屋リストで変更した時の処理
	$(document).on('change', '.default-rooms', function() {
		let roomVal = $('#memo_room_id').val();
		if (roomVal !== "") {
			let houseId = $(`.default-rooms`).find('option:selected').data("houseId");
			$('#memo_house_id').val(houseId);
		}
	});
	//家が変更された時の処理
	$(document).on('change', '#memo_house_id', function() {
		let houseVal = $('#memo_house_id').val();
		if (houseVal !== "") {
			let selectedTemplate = $(`#rooms-of-house${houseVal}`).html();
			$('#memo_room_id').remove();
			$('#memo_house_id').after(selectedTemplate);
		}else {
			$('#memo_room_id').remove();
			$('#memo_house_id').after(defaultRoomSelect);
  	}
	});
});