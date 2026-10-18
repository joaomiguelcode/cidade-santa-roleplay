window.onload = function (e) {
	let menuStructure = {};
	let maxMenuItems = 10;

	function toggleMenuContainer(state) {
		if (state) {
			$("body").show();
			$("#menu_container").show();
		} else {
			$("#menu_container").hide();
			$("body").hide();
		}
	}

	function createMenu(menu, heading, subheading) {
		menuStructure[menu] = {
			menu: menu,
			heading: heading,
			subheading: subheading,
			selectedItem: 0,
			previousSelectedItemID: null,
			container: "<ul id = 'menu_items' class = '" + menu + "' style = 'display: none; order: 5;'></ul>",
			items: {},
			itemsArray: {}
		}

		$("#menu_container").append(menuStructure[menu].container);
	}

	function destroyMenus() {
		$("#menu_container > ul").remove();
		menuStructure = {};
	}

	function menuList(menu) {
		return $("#menu_container > ul." + menu);
	}

	function menuItemIdAttr(id) {
		return String(id).replace(/&/g, "&amp;").replace(/"/g, "&quot;");
	}

	function liForMenuItem(menu, id) {
		var sid = String(id);
		return menuList(menu).find("li").filter(function () {
			return $(this).attr("data-item-id") === sid;
		});
	}

	function listItemDataId($li) {
		var raw = $li.attr("data-item-id");
		if (raw !== undefined && raw !== null && raw !== "") {
			return raw;
		}
		var classes = ($li.attr("class") || "").split(/\s+/);
		for (var i = 0; i < classes.length; i++) {
			if (classes[i] && classes[i] !== "item_selected") {
				return classes[i];
			}
		}
		return "";
	}

	function populateMenu(menu, id, item, item2, translation) {
		menuStructure[menu].items[id] = {
			id: id,
			item: item,
			item2: item2
		}
		var title = item;
		if (translation) {
			title = translation;
		}
		var dataAttr = menuItemIdAttr(id);
		if (item2 == "none") {
			menuList(menu).append("<li class = '" + id + "' data-item-id = '" + dataAttr + "'><span class = 'item1'>" + title + "</span></li>");
		} else {
			menuList(menu).append("<li class = '" + id + "' data-item-id = '" + dataAttr + "'><span class = 'item1'>" + title + "</span> <span class = 'item2' style = 'float: right;'>" + item2 + "</span></li>");
		}
	}

	function finishPopulatingMenu(menu) {
		menuStructure[menu].itemsArray = menuList(menu).children("li").toArray();
	}

	function updateMenuHeading(menu) {
		$("#menu_heading span").text(menuStructure[menu].heading);
	}

	function updateMenuSubheading(menu) {
		$("#menu_subheading span").text(menuStructure[menu].subheading);
	}

	function updateMenuStatus(text) {
		$("#menu_status span").text(text);
	}

	function finalizeSelectedListItem(menu, selectedIndex) {
		var el = menuStructure[menu].itemsArray[selectedIndex];
		if (!el) {
			return;
		}
		var $li = $(el);
		$li.find("i").remove();
		var val1 = listItemDataId($li);
		var row = menuStructure[menu].items[val1];
		if (!row && val1 !== "") {
			var numId = Number(val1);
			if (!isNaN(numId)) {
				row = menuStructure[menu].items[numId];
			}
		}
		if (!row) {
			return;
		}
		var val2 = row.item;
		var val3 = $li.find(".item2").text();
		$.post("https://lscustoms/selectedItem", JSON.stringify({
			id: row.id,
			item: val2,
			item2: val3
		}));
	}

	function toggleMenu(state, menu) {
		if (state) {
			if (menuStructure[menu].selectedItem < maxMenuItems) {
				menuList(menu).empty();

				for (var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++) {
					if (i < maxMenuItems) {
						menuList(menu).append(menuStructure[menu].itemsArray[i]);
					}
				}

				menuList(menu).find(".item_selected").find("i").remove();
				menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
				finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);
			} else {
				menuList(menu).empty();

				for (var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++) {
					if (i > (menuStructure[menu].selectedItem - maxMenuItems) && i <= (maxMenuItems + (menuStructure[menu].selectedItem - maxMenuItems))) {
						menuList(menu).append(menuStructure[menu].itemsArray[i]);
					}
				}

				menuList(menu).find(".item_selected").find("i").remove();
				menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
				finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);
			}

			menuList(menu).show();
		} else {
			menuList(menu).hide();
		}
	}

	function updateItem2TextOnly(menu, id, text) {
		liForMenuItem(menu, id).find(".item2").text(text);
		$.post("https://lscustoms/updateItem2", JSON.stringify({
			item: text
		}));
	}

	function updateItem2Text(menu, id, text) {
		if (menuStructure[menu].previousSelectedItemID == null) {
			liForMenuItem(menu, id).find(".item2").text(text);

			menuStructure[menu].previousSelectedItemID = id
		} else if (id != menuStructure[menu].previousSelectedItemID) {
			var prevID = menuStructure[menu].previousSelectedItemID

			liForMenuItem(menu, prevID).find(".item2").text(menuStructure[menu].items[prevID].item2);

			menuStructure[menu].previousSelectedItemID = id;

			liForMenuItem(menu, id).find(".item2").text(text);
		} else {
			liForMenuItem(menu, id).find(".item2").text(text);

			menuStructure[menu].previousSelectedItemID = null
		}

		$.post("https://lscustoms/updateItem2", JSON.stringify({
			item: text
		}));
	}

	function updateItem2ID(menu, id, text) {
		menuStructure[menu].previousSelectedItemID = id
	}

	function scrollMenuFunctionality(direction, menu) {
		switch (direction) {
			case "down":
				if (menuStructure[menu].selectedItem < (maxMenuItems - 1) && menuStructure[menu].selectedItem < (Object.keys(menuStructure[menu].itemsArray).length - 1)) {
					menuStructure[menu].selectedItem++;

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
					menuList(menu).find(".item_selected").find("i").remove();

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem - 1].classList.remove("item_selected");
					finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);
				} else if (menuStructure[menu].selectedItem < (Object.keys(menuStructure[menu].itemsArray).length - 1)) {
					menuStructure[menu].selectedItem++;

					menuList(menu).append(menuStructure[menu].itemsArray[menuStructure[menu].selectedItem]);
					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
					menuList(menu).find(".item_selected").find("i").remove();

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem - 1].classList.remove("item_selected");
					finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem - maxMenuItems].remove();
				} else if (menuStructure[menu].selectedItem == (Object.keys(menuStructure[menu].itemsArray).length - 1)) {
					menuStructure[menu].selectedItem = 0;

					menuList(menu).find(".item_selected").find("i").remove();
					menuList(menu).empty();

					for (var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++) {
						if (i < maxMenuItems) {
							menuList(menu).append(menuStructure[menu].itemsArray[i]);
						}
					}

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
					menuStructure[menu].itemsArray[Object.keys(menuStructure[menu].itemsArray).length - 1].classList.remove("item_selected");
					finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);
				}
				break;

			case "up":
				if (menuStructure[menu].selectedItem == 0) {
					menuStructure[menu].selectedItem = Object.keys(menuStructure[menu].itemsArray).length - 1;

					menuList(menu).find(".item_selected").find("i").remove();
					menuList(menu).empty();

					for (var i = 0; i < Object.keys(menuStructure[menu].itemsArray).length; i++) {
						if (i > (menuStructure[menu].selectedItem - maxMenuItems) && i <= (maxMenuItems + (menuStructure[menu].selectedItem - maxMenuItems))) {
							menuList(menu).append(menuStructure[menu].itemsArray[i]);
						}
					}

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
					menuStructure[menu].itemsArray[0].classList.remove("item_selected");
					finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);
				} else if (menuStructure[menu].selectedItem < (maxMenuItems) && menuStructure[menu].selectedItem > 0) {
					menuStructure[menu].selectedItem--;

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
					menuList(menu).find(".item_selected").find("i").remove();

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem + 1].classList.remove("item_selected");
					finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);
				} else if (menuStructure[menu].selectedItem > (maxMenuItems - 1)) {
					menuStructure[menu].selectedItem--;

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem].classList.add("item_selected");
					menuList(menu).find(".item_selected").find("i").remove();

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem + 1].classList.remove("item_selected");
					finalizeSelectedListItem(menu, menuStructure[menu].selectedItem);

					menuStructure[menu].itemsArray[menuStructure[menu].selectedItem + 1].remove();

					menuList(menu).prepend(menuStructure[menu].itemsArray[(menuStructure[menu].selectedItem - maxMenuItems) + 1]);
				}
				break;
		}
	}

	function playSoundEffect(soundEffect, volume) {
		var audioPlayer = null;

		if (audioPlayer != null) {
			audioPlayer.pause();
		}

		audioPlayer = new Howl({ src: ["./sounds/" + soundEffect + ".ogg"] });
		audioPlayer.volume(volume);
		audioPlayer.play();
	}

	window.addEventListener("message", function (event) {
		var eventData = event.data;

		if (eventData.toggleMenuContainer) {
			toggleMenuContainer(eventData.state);
		}

		if (eventData.createMenu) {
			createMenu(eventData.menu, eventData.heading, eventData.subheading);
		}

		if (eventData.destroyMenus) {
			destroyMenus();
		}

		if (eventData.populateMenu) {
			populateMenu(eventData.menu, eventData.id, eventData.item, eventData.item2, eventData.translation);
		}

		if (eventData.finishPopulatingMenu) {
			finishPopulatingMenu(eventData.menu);
		}

		if (eventData.updateMenuHeading) {
			updateMenuHeading(eventData.menu);
		}

		if (eventData.updateMenuSubheading) {
			updateMenuSubheading(eventData.menu);
		}

		if (eventData.updateMenuStatus) {
			updateMenuStatus(eventData.statusText)
		}

		if (eventData.toggleMenu) {
			toggleMenu(eventData.state, eventData.menu);
		}

		if (eventData.updateItem2Text) {
			updateItem2Text(eventData.menu, eventData.id, eventData.item2)
		}

		if (eventData.updateItem2TextOnly) {
			updateItem2TextOnly(eventData.menu, eventData.id, eventData.item2)
		}

		if (eventData.scrollMenuFunctionality) {
			scrollMenuFunctionality(eventData.direction, eventData.menu);
		}

		if (eventData.playSoundEffect) {
			playSoundEffect(eventData.soundEffect, eventData.volume);
		}
	});
}
