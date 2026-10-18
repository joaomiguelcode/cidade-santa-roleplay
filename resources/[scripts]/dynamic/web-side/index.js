var ICONS = {
	"Jogador": `
		<svg width="16" height="18" viewBox="0 0 16 18" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path id="Vector" d="M7.875 9C9.06847 9 10.2131 8.52589 11.057 7.68198C11.9009 6.83807 12.375 5.69347 12.375 4.5C12.375 3.30653 11.9009 2.16193 11.057 1.31802C10.2131 0.474106 9.06847 0 7.875 0C6.68153 0 5.53693 0.474106 4.69302 1.31802C3.84911 2.16193 3.375 3.30653 3.375 4.5C3.375 5.69347 3.84911 6.83807 4.69302 7.68198C5.53693 8.52589 6.68153 9 7.875 9ZM6.26836 10.6875C2.80547 10.6875 0 13.493 0 16.9559C0 17.5324 0.467578 18 1.04414 18H14.7059C15.2824 18 15.75 17.5324 15.75 16.9559C15.75 13.493 12.9445 10.6875 9.48164 10.6875H6.26836Z" class="colored" fill="var(--color-main-500)"/>
		</svg>
	`,
	"Roupas": `
		<svg width="21" height="16" viewBox="0 0 21 16" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path id="Vector" d="M6.94975 0C7.20568 0 7.41896 0.178125 7.49771 0.4125C7.9013 1.62188 9.09237 2.5 10.5 2.5C11.9076 2.5 13.0987 1.62188 13.5023 0.4125C13.581 0.178125 13.7943 0 14.0503 0H14.4637C15.2019 0 15.914 0.246875 16.4816 0.696875L20.6225 3.98125C20.839 4.15313 20.9736 4.40312 20.9965 4.67188C21.0195 4.94063 20.9276 5.20625 20.7406 5.40938L18.9031 7.40938C18.5291 7.81875 17.8794 7.86563 17.4397 7.51875L15.7499 6.17812V14C15.7499 15.1031 14.8082 16 13.6499 16H7.35006C6.19179 16 5.25009 15.1031 5.25009 14V6.17812L3.56028 7.51875C3.12388 7.86563 2.4742 7.81875 2.09687 7.40938L0.259398 5.40938C0.0723702 5.20625 -0.0195032 4.94063 0.0034652 4.67188C0.0264335 4.40312 0.160962 4.15313 0.377521 3.98125L4.51839 0.696875C5.08603 0.246875 5.79805 0 6.53632 0H6.94975Z" fill="var(--color-main-500)"/>
		</svg>
	`,
	"Experiência": `
		<svg width="19" height="18" viewBox="0 0 19 18" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path id="Vector" d="M10.3784 0.632742C10.1905 0.246066 9.7935 0 9.35745 0C8.92141 0 8.52791 0.246066 8.33647 0.632742L6.05699 5.28339L0.966261 6.02862C0.540852 6.0919 0.186345 6.38718 0.0551772 6.79143C-0.0759906 7.19568 0.0303615 7.64211 0.335238 7.94091L4.02921 11.5651L3.15712 16.6868C3.08622 17.1086 3.26347 17.5375 3.61443 17.7871C3.96539 18.0367 4.4298 18.0683 4.81267 17.8679L9.361 15.46L13.9093 17.8679C14.2922 18.0683 14.7566 18.0402 15.1076 17.7871C15.4585 17.534 15.6358 17.1086 15.5649 16.6868L14.6892 11.5651L18.3832 7.94091C18.6881 7.64211 18.798 7.19568 18.6633 6.79143C18.5286 6.38718 18.1776 6.0919 17.7522 6.02862L12.6579 5.28339L10.3784 0.632742Z" fill="var(--color-main-500)"/>
		</svg>
	`,
	"Outros": `
		<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path id="Vector" d="M9 18C11.3869 18 13.6761 17.0518 15.364 15.364C17.0518 13.6761 18 11.3869 18 9C18 6.61305 17.0518 4.32387 15.364 2.63604C13.6761 0.948212 11.3869 0 9 0C6.61305 0 4.32387 0.948212 2.63604 2.63604C0.948212 4.32387 0 6.61305 0 9C0 11.3869 0.948212 13.6761 2.63604 15.364C4.32387 17.0518 6.61305 18 9 18ZM9 4.5C9.46758 4.5 9.84375 4.87617 9.84375 5.34375V9.28125C9.84375 9.74883 9.46758 10.125 9 10.125C8.53242 10.125 8.15625 9.74883 8.15625 9.28125V5.34375C8.15625 4.87617 8.53242 4.5 9 4.5ZM7.875 12.375C7.875 12.0766 7.99353 11.7905 8.20451 11.5795C8.41548 11.3685 8.70163 11.25 9 11.25C9.29837 11.25 9.58452 11.3685 9.79549 11.5795C10.0065 11.7905 10.125 12.0766 10.125 12.375C10.125 12.6734 10.0065 12.9595 9.79549 13.1705C9.58452 13.3815 9.29837 13.5 9 13.5C8.70163 13.5 8.41548 13.3815 8.20451 13.1705C7.99353 12.9595 7.875 12.6734 7.875 12.375Z" fill="var(--color-main-500)"/>
		</svg>
	`,
	"Comprar Voucher": `
		<svg width="20" height="16" viewBox="0 0 20 16" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path d="M2 2.75C2 1.7835 2.7835 1 3.75 1H16.25C17.2165 1 18 1.7835 18 2.75V5.05C16.8602 5.26337 16 6.26339 16 7.46667C16 8.66994 16.8602 9.66996 18 9.88333V13.25C18 14.2165 17.2165 15 16.25 15H3.75C2.7835 15 2 14.2165 2 13.25V9.88333C3.13982 9.66996 4 8.66994 4 7.46667C4 6.26339 3.13982 5.26337 2 5.05V2.75Z" fill="var(--color-main-500)"/>
			<path d="M8 4.5H12M8 7.5H12M8 10.5H10.75" stroke="rgba(255,255,255,0.9)" stroke-width="1.2" stroke-linecap="round"/>
		</svg>
	`,
	"Portas": `
		<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0px" y="0px" viewBox="0 0 100 125" enable-background="new 0 0 100 100" xml:space="preserve">
			<path d="M87.5,29.5h-35c-1.71,0-4.032,0.774-5.4,1.8l-36,27c-1.482,1.112-2.6,3.348-2.6,5.2V91c0,2.206,1.794,4,4,4h75  c2.206,0,4-1.794,4-4V33.5C91.5,31.294,89.706,29.5,87.5,29.5z M82.5,70H70c-0.828,0-1.5-0.672-1.5-1.5S69.172,67,70,67h12.5  c0.828,0,1.5,0.672,1.5,1.5S83.328,70,82.5,70z M85,58.5c0,1.375-1.125,2.5-2.5,2.5h-60c-1.375,0-1.608-0.686-0.519-1.524  l28.537-21.951C51.608,36.686,53.625,36,55,36h12.5c1.375,0,3.625,0,5,0h10c1.375,0,2.5,1.125,2.5,2.5V58.5z" fill="var(--color-main-500)"/>
		</svg>
	`,
	"Veículo": `
		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
			<path d="M135.2 117.4L109.1 192H402.9l-26.1-74.6C372.3 104.6 360.2 96 346.6 96H165.4c-13.6 0-25.7 8.6-30.2 21.4zM39.6 196.8L74.8 96.3C88.3 57.8 124.6 32 165.4 32H346.6c40.8 0 77.1 25.8 90.6 64.3l35.2 100.5c23.2 9.6 39.6 32.5 39.6 59.2V400v48c0 17.7-14.3 32-32 32H448c-17.7 0-32-14.3-32-32V400H96v48c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32V400 256c0-26.7 16.4-49.6 39.6-59.2zM128 288a32 32 0 1 0 -64 0 32 32 0 1 0 64 0zm288 32a32 32 0 1 0 0-64 32 32 0 1 0 0 64z" fill="var(--color-main-500)"/>
		</svg>
	`
}

ICONS["Buy Voucher"] = ICONS["Comprar Voucher"];
ICONS["Acheter un voucher"] = ICONS["Comprar Voucher"];
ICONS["Voucher kaufen"] = ICONS["Comprar Voucher"];
ICONS["شراء قسيمة"] = ICONS["Comprar Voucher"];

function getIcon(title) {
	const normalizedTitle = String(title || "").toLowerCase();

	if (normalizedTitle.includes("voucher") || normalizedTitle.includes("قسيمة")) {
		return ICONS["Comprar Voucher"];
	}

	return ICONS[title] || "";
}

$(document).ready(function () {
	loadTheme((theme) => {})

  var translations = {}

  fetch('https://localization/getLang', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({ resourceName: 'dynamic' })
  })
  .then(response => response.ok ? response.json() : {})
  .then(data => {
      if (data) translations = data;
  })
  .catch(() => {});

	const buttons = [];
	const submenus = [];
	var normalButtons = 0;

	document.onkeyup = function (data) {
		if (data["which"] == 27) {
			for (i = 1; i <= normalButtons; ++i) {
				$("#normalbutton-" + i).remove();
			}

			normalButtons = 0;
			$("button").remove();
			$("#goback").remove();
			buttons["length"] = 0;
			submenus["length"] = 0;
			$(".Container").html("");

			$.post("http://dynamic/close");
		}
	}

	window.addEventListener("message", function (event) {
		var item = event["data"];

		if (item["openUrl"] && item["openUrl"] !== "") {
			window.invokeNative('openUrl', item["openUrl"]);
			return;
		}

		if (item["addbutton"] == true) {
			const isObjectParam = item["par"] !== null && typeof item["par"] === "object";
			const serializedParam = isObjectParam
				? encodeURIComponent(JSON.stringify(item["par"]))
				: item["par"];

			if (item.id == false || null) {
				normalButtons = normalButtons + 1;
				var b = (`
				<div
					id="normalbutton-${normalButtons}"
					data-trigger="${item["trigger"]}"
					data-parm="${serializedParam}"
					data-param-json="${isObjectParam}"
					data-server="${item["server"]}"
					data-link="${item["link"] || ""}"
					class="normalbutton ${item["title"] == "Guardar" ? "amarelo" : ""}"
				>
					<div class="flex-1">
						${getIcon(item["title"])}
						<div class="flex">
							<div class="title">
								${item["title"]}
							</div>
							<div class="description" >
								${item["description"]}
							</div>
						</div>
						<div class="button">
							<img src="./public/images/icon.svg">
						</div>
					</div>
				</div>`);
				$(".Container").append(b);
				buttons.push(b);
			} else {
				var b = (`
					<button
						id="${item["id"]}" data-trigger="${item["trigger"]}"
						data-parm="${serializedParam}"
						data-param-json="${isObjectParam}"
						data-server="${item["server"]}"
						data-link="${item["link"] || ""}"
						class="a btn"
					>
						<div class="flex-1">
							${getIcon(item["title"])}
							<div class="flex">
								<div class="title">
									${item["title"]}
								</div>
								<div class="description" >
									${item["description"]}
								</div>
							</div>
						</div>
						<div class="button" style="margin-right: 10%;width: 2.7rem;height: 1.9rem;">
							<img src="./public/images/icon.svg">
						</div>
					</button>`);
				buttons.push(b);
			}
		} else if (item["addmenu"] == true) {
			var aa = (`<button data-menu="` + item["menuid"] + `" class="b btn"><div class="flex-1">
				${getIcon(item["title"])}
				<div class="flex"><div class="title">` + item["title"] + `</div><div class="description" >` + item["description"] + `</div></div><div class="button"><img src="./public/images/icon.svg"></div></button>`)
			$(".Container").append(aa);
			submenus.push(aa);
		}

		if (item["close"] == true) {
			for (i = 1; i <= normalButtons; ++i) {
				$("#normalbutton-" + i).remove();
			}

			normalButtons = 0;
			$("button").remove();
			$("#goback").remove();
			buttons["length"] = 0;
			submenus["length"] = 0;
			$(".Container").html("");

			$.post("http://dynamic/close");
		}

		if (item["show"] == true) {
			$(".Container").show();
		}
	});

	function GetButtonParam(button) {
		const serializedParam = button.attr("data-parm");

		if (button.attr("data-param-json") !== "true") {
			return serializedParam;
		}

		return JSON.parse(decodeURIComponent(serializedParam));
	}

	$("body").on("click", ".normalbutton", function () {
		const link = $(this).attr("data-link");

		if (link && link !== "") {
			window.invokeNative('openUrl', link)
			return;
		}

		$.post("http://dynamic/clicked", JSON.stringify({ trigger: $(this).attr("data-trigger"), param: GetButtonParam($(this)), server: $(this).attr("data-server") }));
	});

	$("body").on("click", ".a", function () {
		const link = $(this).attr("data-link");

		if (link && link !== "") {
			window.invokeNative('openUrl', link)
			return;
		}

		$.post("http://dynamic/clicked", JSON.stringify({ trigger: $(this).attr("data-trigger"), param: GetButtonParam($(this)), server: $(this).attr("data-server") }));
	});

	$("body").on("click", ".b", function () {
		$(".b").remove();
		$(".a").remove();

		for (i = 1; i <= normalButtons; ++i) {
			$("#normalbutton-" + i).hide();
		}

		var goBack = (`<div id="goback" class="normalbutton amarelo"><div class="flex-1"><div class="flex"><div class="title">${translations.back}</div><div class="description" >${translations.click_and_go_back_to_the_previous_options}</div></div></div><div class="button-goback" style="margin-left: 6%;width: 2.7rem;height: 1.9rem;"><img src="./public/images/icon.svg"></div></div>`);
		$(".Container").append(goBack).show();

		var menuid = $(this).attr("data-menu");
		for (i = 0; i < buttons["length"]; ++i) {
			var div = buttons[i];
			var match = div.match(`id="` + menuid + `"`);
			if (match) {
				$(".Container").append(div);
			}
		}
	});

	$("body").on("click", "[id=goback]", function () {
		$(".b").remove();
		$(".a").remove();
		$("button").remove();
		$("#goback").remove();
		$(".Container").append(submenus).show();

		for (i = 1; i <= normalButtons; ++i) {
			$("#normalbutton-" + i).show();
		}
	});
});
