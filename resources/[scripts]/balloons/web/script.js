const balloonContainer = document.getElementById('balloon-container')
const congratsContainer = document.getElementById('congratulations')
const premiumContainer = document.getElementById('premium')
const premiumBox = document.getElementsByClassName('premium-box')

function random(num) {
    return Math.floor(Math.random() * num)
}

function getRandomStyles() {
    var r = random(255)
    var g = random(255)
    var b = random(255)
    var mt = random(200)
    var ml = random(50)
    var dur = random(15) + 5

    return `
  background-color: rgba(${r},${g},${b},1.0);
  color: rgba(${r},${g},${b},1.0); 
  box-shadow: inset -7px -3px 10px rgba(${r - 10},${g - 10},${b - 10},1.0);
  margin: ${mt}px 0 0 ${ml}px;
  animation: float ${dur}s ease-in infinite
  `
}

function createBalloons(num) {
    for (var i = num; i > 0; i--) {
        var balloon = document.createElement('div')
        balloon.className = 'balloon'
        balloon.style.cssText = getRandomStyles()
        balloonContainer.append(balloon)
    }
}

function removeBalloons() {
    balloon = document.querySelectorAll('.balloon')
    for (var i = 0; i < balloon.length; i++) {
        balloon[i].remove()
    }
}

window.addEventListener('load', () => {
    console.log('[DEBUG] window loaded')

    createBalloons(30)
})
let translations
$(document).ready(function () {
    loadTheme((theme) => { })
    fetch('https://localization/getLang', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({ resourceName: 'balloons' })
    })
        .then(response => response.ok ? response.json() : {})
        .then(data => {
            if (!data) return;
            translations = data;
            if (translations.balloons_title) $("#lang-title").html(translations.balloons_title);
            if (translations.balloons_decs) $("#lang-desc").html(translations.balloons_decs);
            if (translations.balloons_vip) $("#lang-desc").append(translations.balloons_vip);
            if (translations.balloons_button) $("#lang-button").html(translations.balloons_button);
            if (translations.balloons_entrygroup) $("#lang-entry-group").html(translations.balloons_entrygroup);
            if (translations.balloons_wpptext) $("#lang-whats-text").html(translations.balloons_wpptext);
        })
        .catch(() => {});


    window.addEventListener('message', async (event) => {
        const item = event.data || event.detail

        document.querySelector('#close').addEventListener('click', () => {
            console.log('[DEBUG] close clicked');
            $('.video').html('');
            $.post('http://balloons/close')
            $(premiumContainer).css('display', 'none')
            $(premium).css('display', 'none')
            $('.content').html('')
            premiumBox.style.display = 'none'
            console.log('[DEBUG] close clicked');
        });

        document.querySelector('.whatsapp').addEventListener('click', () => {
            console.log('[DEBUG] whatsapp clicked');
            $('.video').html('');
            $.post('http://balloons/whatsapp', JSON.stringify({ type: item.vip }));
            $(premiumContainer).css('display', 'none');

            $('.content').html('');

            premiumBox.style.display = 'none';
        });

        document.querySelector('.next-button').addEventListener('click', () => {
            console.log('[DEBUG] next clicked');
            const videoElement = document.createElement('video');
            videoElement.className = 'video-js vjs-default-skin';
            videoElement.id = 'video-player';

            const videoContainer = document.getElementsByClassName('video')[0];

            if (videoContainer.children.length > 0) {
                videoContainer.innerHTML = '';
            }

            videoContainer.innerHTML = '';
            videoContainer.appendChild(videoElement);

            if (videojs.getPlayers()['video-player']) {
                videojs.getPlayers()['video-player'].dispose();
            }
            videojs('video-player', {
                controls: false,
                autoplay: true,
                muted: false,
                preload: true,
                sources: [{
                    src: item.video,
                    type: 'video/youtube'
                }]
            }, function () {
                console.log('Video.js player initialized with YouTube');
            });

            congratsContainer.style.display = 'none';
            premiumContainer.style.display = 'flex';
        });

        setTimeout(() => {
            $(balloonContainer).css('display', 'none')

            if (!item.pass) {
                $(premiumContainer).css('display', 'flex')
                $(premium).css('display', 'inline-flex')
            }
        }, item.duration * 1000)
        console.log('[DEBUG] message received', JSON.stringify(item))
        switch (item.Action) {
            case 'open':
                $(balloonContainer).css('display', 'flex')
                $(balloonContainer).find('.title').text(item.title)
                $(balloonContainer).find('.message').html(item.message)
                $(balloonContainer).show()
                createBalloons(300)
                $(premiumContainer).css('display', 'none')
                premiumContainer.style.display = 'none';

                if (!item.pass) {
                    congratsContainer.style.display = 'flex';
                    premiumContainer.style.display = 'none';
                    $('.video').html('');
                    $('#vip').html('[VIP] ' + item.vip)
                    $('.video span').css('display', 'none')
                    $('.content').html('')
                    $('#vip').html(translations.balloons_vip2 + item.vip)

                    $('.content').append(translations.balloons_vip3)
                    item.benefits.forEach((benefit, index) => {
                        $('.content').append(`
                <div class="item">
                  <div class="item-number">${index + 1}</div>
                  <div class="item-box">
                    <h2>
                      ${benefit.title}
                    </h2>
                    <p>
                      ${benefit.description}
                    </p>
                  </div>
                </div>
            `)
                    })
                }
                break
        }
    })
})
