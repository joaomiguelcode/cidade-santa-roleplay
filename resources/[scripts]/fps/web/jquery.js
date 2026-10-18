var Rows = [];
var saved = "";
var RowsData = [];

// Simple range slider progress functionality
const updateRangeProgress = () => {
	const range = document.getElementById('range');
	if (range) {
		const value = range.value;
		const percentage = (value / 100) * 100;
		
		// Update the track background to show progress
		range.style.background = `linear-gradient(
			to right,
			var(--green) 0%,
			var(--green) ${percentage}%,
			#333333 ${percentage}%,
			#333333 100%
		)`;
	}
};

// Initialize range slider
$(document).ready(() => {
	const range = document.getElementById('range');
	if (range) {
		// Set initial progress
		updateRangeProgress();
		
		// Update progress on input
		range.addEventListener('input', updateRangeProgress);
		range.addEventListener('change', updateRangeProgress);
	}
});
// ---------------------------------------------------------------------------------------------
const OpenMenu = (data) => {
	$(".Keyboard-Wrapper").fadeIn(200);

	$("#range").val(data.range);
	
	// Update range progress after setting value
	setTimeout(() => {
		updateRangeProgress();
	}, 100);

	$("#switch-1-box").prop("checked", data.switch1);
	$("#switch-1").html(data.switch1Title);

	$("#switch-2-box").prop("checked", data.switch2);
	$("#switch-2").html(data.switch2Title);
}


// ---------------------------------------------------------------------------------------------
const CloseMenu = () => {
  console.log("Closing Menu")
  console.log(saved + " saved")
	$(".Keyboard-Wrapper").fadeOut(200)
	$(saved).remove();

	$(this).dequeue();
}
// ---------------------------------------------------------------------------------------------
function SubmitData(){
	var range = $("#range").val();
	var switch1 = $("#switch-1-box").prop("checked");
	var switch2 = $("#switch-2-box").prop("checked");

	var returnData = {
		range: range,
		switch1: switch1,
		switch2: switch2,
	}

	console.log(returnData)

	PostData({ data: returnData })
  console.log("Data Posted")
	CloseMenu();
}
// ---------------------------------------------------------------------------------------------
const PostData = (data) => {
	return $.post("https://fps/success",JSON.stringify(data))
}
// ---------------------------------------------------------------------------------------------
const CancelMenu = () => {
	CloseMenu()

  console.log("Menu Cancelled")
	$.post("https://fps/failure")
}

$(() => {
	$("#submit").on("click",() => {
		SubmitData();
	})
})

// ---------------------------------------------------------------------------------------------
window.addEventListener("message",(evt) => {
	const data = evt.data
	const info = data.data
	const action = data.action

  var translations = {}

    fetch('https://localization/getLang', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ resourceName: 'fps' })
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);
        const translations = data;

        document.querySelector(".input-range__label").innerHTML = translations.distance_of_rendering;
        document.querySelector("#switch-1").innerHTML = translations.boost_1;
        document.querySelector("#switch-2").innerHTML = translations.boost_2;
        document.querySelector(".btn-success").innerHTML = translations.apply;
    })
    .catch(error => {
        console.error('Error fetching translations:', error);
    });


	switch (action){
		case "OPEN_MENU":
			return OpenMenu(info);

		case "CLOSE_MENU":
      console.log("Closing Menu")
			return CloseMenu();

		default:
			return;
	}
})
// ---------------------------------------------------------------------------------------------
document.onkeyup = function(event){
	event = event || window.event;
	var charCode = event.keyCode || event.which;

	if (charCode == 27){
    console.log("Escape Pressed")
		CancelMenu();
	}
};

loadTheme((theme) => {})
