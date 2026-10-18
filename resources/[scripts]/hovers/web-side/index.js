import { HotBar, Hoverfy, Taskbar, Verification } from './modules/index.js'

let translations;

$(document).ready(function () {
  var globalTheme = undefined
  loadTheme((theme) => {
    globalTheme = theme
  })

  fetch('http://hovers/getLang', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({ resourceName: 'hovers' })
  })
    .then(response => response.json())
    .then(data => {
      translations = data;
    });

  window.addEventListener('message', function (event) {
    switch (event['data']['page']) {
      case 'hot-bar':
        HotBar(event)
        break
      case 'taskbar':
        Taskbar(event, globalTheme, translations)
        break
      case 'hoverfy':
        Hoverfy(event)
        break
      case 'verification':
        Verification(event, translations)
        break
    }
  })

  $('body').mousedown((e) => {
    if (e.button == 1) return false
  })
})
