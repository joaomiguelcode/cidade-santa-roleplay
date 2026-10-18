let canvas = document.getElementById('canvas')
let ctx = canvas.getContext('2d')

let W = canvas.width
let H = canvas.height
let degrees = 0
let p = 0
let pStep = 2 / 360
let time = 0
let color = '#CCC'
let bgcolor = 'rgba(15,15,15,.75)'
let key_to_press
let g_start, g_end
let animation_loop
let theme = undefined

const KEY_POOL = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

let R = {
  cx: 150, cy: 150, radius: 100, ringWidth: 20,
  dir: 1, speedAmp: 0.15, targetColor: 'green',
  numX: 0, numY: 0, numSize: 112, numColor: '#EAEAEA'
}

function getRandomInt(min, max) {
  min = Math.ceil(min)
  max = Math.floor(max)
  return Math.floor(Math.random() * (max - min + 1) + min)
}

function pick(arr) {
  return arr[Math.floor(Math.random() * arr.length)]
}

function drawNoise() {
  ctx.save()
  ctx.globalAlpha = 0.08
  for (let i = 0; i < 16; i++) {
    ctx.beginPath()
    ctx.strokeStyle = `rgba(${getRandomInt(120, 220)}, ${getRandomInt(120, 220)}, ${getRandomInt(120, 220)}, 0.4)`
    ctx.lineWidth = getRandomInt(1, 2)
    let x = getRandomInt(0, W)
    let y = getRandomInt(0, H)
    ctx.moveTo(x, y)
    ctx.lineTo(x + getRandomInt(-40, 40), y + getRandomInt(-40, 40))
    ctx.stroke()
  }
  ctx.restore()
}

function drawNumber(num, x, y) {
  ctx.save()

  ctx.translate(x, y)
  ctx.rotate((getRandomInt(-3, 3) * Math.PI) / 180)

  ctx.font = `bold ${R.numSize}px "Poppins", sans-serif`
  ctx.textAlign = 'center'
  ctx.textBaseline = 'middle'

  ctx.shadowBlur = 10
  ctx.shadowColor = 'rgba(0, 0, 0, 0.55)'

  ctx.fillStyle = R.numColor
  ctx.fillText(num, 0, 0)

  ctx.shadowBlur = 0
  ctx.strokeStyle = 'rgba(0, 0, 0, 0.30)'
  ctx.lineWidth = 1.5
  ctx.strokeText(num, 0, 0)

  ctx.restore()
}

function init() {
  ctx.clearRect(0, 0, W, H)

  let centerX = R.cx
  let centerY = R.cy

  ctx.beginPath()
  ctx.strokeStyle = bgcolor
  ctx.lineWidth = R.ringWidth
  ctx.arc(centerX, centerY, R.radius, 0, Math.PI * 2, false)
  ctx.stroke()

  let targetColor = theme ? color : R.targetColor
  let grad = ctx.createConicGradient(0, centerX, centerY)
  grad.addColorStop(0, targetColor)
  grad.addColorStop(0.5, `rgba(${getRandomInt(120, 200)}, 255, ${getRandomInt(120, 200)}, 0.85)`)
  grad.addColorStop(1, targetColor)

  let radians = (degrees * Math.PI) / 180

  if (R.dir === 1) {
    ctx.beginPath()
    ctx.strokeStyle = grad
    ctx.lineWidth = R.ringWidth
    ctx.lineCap = 'round'
    ctx.arc(centerX, centerY, R.radius, g_start - Math.PI / 2, g_end - Math.PI / 2, false)
    ctx.stroke()

    ctx.beginPath()
    ctx.strokeStyle = '#CCC'
    ctx.lineWidth = R.ringWidth
    ctx.arc(centerX, centerY, R.radius, -Math.PI / 2, radians - Math.PI / 2, false)
    ctx.stroke()
  } else {
    ctx.beginPath()
    ctx.strokeStyle = grad
    ctx.lineWidth = R.ringWidth
    ctx.lineCap = 'round'
    ctx.arc(centerX, centerY, R.radius, -Math.PI / 2 - g_start, -Math.PI / 2 - g_end, true)
    ctx.stroke()

    ctx.beginPath()
    ctx.strokeStyle = '#CCC'
    ctx.lineWidth = R.ringWidth
    ctx.arc(centerX, centerY, R.radius, -Math.PI / 2, -Math.PI / 2 - radians, true)
    ctx.stroke()
  }

  drawNoise()
  drawNumber(key_to_press, centerX + R.numX, centerY + R.numY)
}

function repositionWidget() {
  $('.taskbar').css({
    display: 'flex',
    transform: `translate(${getRandomInt(-10, 10)}px, ${getRandomInt(-10, 10)}px)`
  })
}

function draw(Lengths) {
  if (typeof animation_loop !== 'undefined') clearInterval(animation_loop)

  key_to_press = pick(KEY_POOL)

  R.cx = W / 2 + getRandomInt(-16, 16)
  R.cy = H / 2 + getRandomInt(-16, 16)
  R.radius = getRandomInt(92, 108)
  R.ringWidth = getRandomInt(18, 22)
  R.dir = pick([1, -1])
  R.speedAmp = (getRandomInt(12, 20) / 100) * pick([1, -1])
  R.targetColor = `rgb(${getRandomInt(70, 160)}, ${getRandomInt(170, 255)}, ${getRandomInt(90, 170)})`

  R.numSize = getRandomInt(106, 116)
  R.numColor = '#EAEAEA'
  R.numX = getRandomInt(-8, 8)
  R.numY = getRandomInt(-8, 8)

  g_start = getRandomInt(10, 42) / 10
  g_end = g_start + getRandomInt(4, 8) / 10

  if (theme) {
    const r = getRandomInt(100, 255)
    const g = getRandomInt(100, 255)
    const b = getRandomInt(100, 255)
    color = `rgb(${r}, ${g}, ${b})`
  }

  p = 0
  degrees = 0
  pStep = 2 / 360

  time = Lengths
  animation_loop = setInterval(animate_to, time)

  repositionWidget()

  setTimeout(() => {
    $("#canvas").css("display", "block")
    $('#tasktip').css('display', 'block')
  }, 100)
}

function animate_to() {
  p += pStep
  if (p >= 1) {
    degrees = 360
    wrong()
    return
  }
  degrees = 360 * (p + R.speedAmp * Math.sin(Math.PI * p))
  if (degrees < 0) degrees = 0
  init()
}

function correct() {
  clearInterval(animation_loop)
  $.post('https://hovers/taskSuccess')
  $("#canvas").css("display", "none")
  $('#tasktip').css('display', 'none')
}

function wrong() {
  clearInterval(animation_loop)
  $.post('https://hovers/taskFailure')
  $("#canvas").css("display", "none")
  $('#tasktip').css('display', 'none')
}

document.addEventListener('keydown', function (ev) {
  let key_pressed = ev.key

  if (KEY_POOL.includes(key_pressed)) {
    if (key_pressed === key_to_press) {
      let d_start = (180 / Math.PI) * g_start
      let d_end = (180 / Math.PI) * g_end
      if (degrees < d_start) {
        wrong()
      } else if (degrees > d_end) {
        wrong()
      } else {
        correct()
      }
    } else {
      wrong()
    }
  }
})

export const Taskbar = (event, globalTheme, globalTranslations) => {
  if (globalTheme) {
    theme = globalTheme
  }
  switch (event.data.action) {
    case 'open':
      $('.taskbar').css('display', 'flex')
      if (globalTranslations && globalTranslations.tasktip) {
        $('#tasktip').text(globalTranslations.tasktip)
      }
      if (event.data.time == 1) {
        time = 4
      } else {
        time = event.data.time / 1000 + 10
      }
      draw(time)
      break
    case 'close':
      clearInterval(animation_loop)
      setTimeout(() => {
        $('.taskbar').removeAttr('style')
        $('.taskbar').css('display', 'none')
        $('#tasktip').css('display', 'none')
        $("#canvas").css("display", "none")
        $("#canvas").css("transform", "rotate(0deg)")
      }, 100)
      break
  }
}
