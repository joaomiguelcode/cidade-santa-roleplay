// -------------------------------------------------------------------------------------------
window.addEventListener("message",function(event){
	switch (event["data"]["Action"]){
		case "Radio":
			if (event["data"]["Show"] == true){
				if ($("#Radio").css("display") === "none"){
					$("#Radio").show("slide",{ direction: "down" },500);
				}
			} else {
				if ($("#Radio").css("display") === "block"){
					$("#Radio").hide("slide",{ direction: "down" },500);
				}
			}
		break;

		case "FORCE_STOP_CASINO":
			fetch('https://pickle_casinos/exitGame', {} )
		break;

		case "Frequency":
			$(".Radio").html(event["data"]["Frequency"]);
		break;
	}
});
// -------------------------------------------------------------------------------------------
$(document).ready(function(){
	document.onkeyup = function(event){
		switch (event["key"]){
			case "Escape":
				if ($("#Radio").css("display") === "block"){
					$("#Radio").hide("slide",{ direction: "down" },500);
					$.post("http://santa_radio/RadioClose");
				}
			break;

			case "Enter":
				if ($("#Radio").css("display") === "block"){
					var Frequency = parseInt($(".RadioFrequency").val());
					$.post("http://santa_radio/RadioActive",JSON.stringify({ Frequency }));
					$(".RadioFrequency").val("");
				}
			break;
		}
	}
});
// -------------------------------------------------------------------------------------------
$(document).on("click",".RadioInative",function(){
	$.post("http://santa_radio/RadioInative");
	$(".RadioFrequency").val("");
});
// -------------------------------------------------------------------------------------------
$(document).on("click",".RadioActive",function(){
	var Frequency = parseInt($(".RadioFrequency").val());
	$.post("http://santa_radio/RadioActive",JSON.stringify({ Frequency }));
	$(".RadioFrequency").val("");
});