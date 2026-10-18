/* ---------------------------------------------------------------------------------------------------------------- */
var translations = {};

$(document).ready(function () {
	$.post("https://localization/getLang", JSON.stringify({ resourceName: "tencode" }), function (data) {
		if (data) {
			translations = data;
			$("#topRadar").html(translations["loading"]);
			$("#botRadar").html(translations["loading"]);
		}
	});

	document.onkeyup = function (data) {
		if (data["which"] == 27) {
			$.post("http://tencode/closeSystem");
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
window.addEventListener("message", function (event) {
	if (event["data"]["tencode"] == true) {
		$("#divCode").css("display", "block");
	}

	if (event["data"]["tencode"] == false) {
		$("#divCode").css("display", "none");
	}

	if (event["data"]["radar"] == true) {
		$("#topRadar").css("display", "block");
		$("#botRadar").css("display", "block");
	}

	if (event["data"]["radar"] == false) {
		$("#topRadar").css("display", "none");
		$("#botRadar").css("display", "none");
	}

	if (event["data"]["radar"] == "top") {
		$("#topRadar").html("<legend>" + translations["frontRadar"] + "</legend><c>" + translations["plate"] + "</c> " + event["data"]["plate"] + "<br><c>" + translations["model"] + "</c> <v>" + event["data"]["Model"] + "</v><br><c>" + translations["speed"] + "</c> " + parseInt(event["data"]["speed"]) + " KMH");
	}

	if (event["data"]["radar"] == "bot") {
		$("#botRadar").html("<legend>" + translations["rearRadar"] + "</legend><c>" + translations["plate"] + "</c> " + event["data"]["plate"] + "<br><c>" + translations["model"] + "</c> <v>" + event["data"]["Model"] + "</v><br><c>" + translations["speed"] + "</c> " + parseInt(event["data"]["speed"]) + " KMH");
	}
});
/* ---------------------------------------------------------------------------------------------------------------- */
const clickCode = (data) => {
	$.post("http://tencode/sendCode", JSON.stringify({ code: data }));
};