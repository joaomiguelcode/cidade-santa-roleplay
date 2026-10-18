const icons = [
    { key: 'icon_car', svg: `<path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 13.1V16c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/>` },
    { key: 'icon_bird', svg: `<path d="M16 7h.5a2.5 2.5 0 0 1 0 5H16"/><path d="M8 7V3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v4"/><path d="M10 17v4a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1v-4"/><path d="M4 14c.5-1.5 1.5-3 3-3V7c0-1.1.9-2 2-2h6c1.1 0 2 .9 2 2v4c1.5 0 2.5 1.5 3 3 .5 1.5 0 3.5-1 4.5S15 19 12 19s-6-1.5-7-2.5S3.5 15.5 4 14z"/>` },
    { key: 'icon_house', svg: `<path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>` },
    { key: 'icon_key', svg: `<circle cx="7.5" cy="15.5" r="5.5"/><path d="m21 2-9.6 9.6"/><path d="m15.5 7.5 3 3L22 7l-3-3"/><path d="m11 11 3 3"/>` },
    { key: 'icon_money', svg: `<rect width="20" height="12" x="2" y="6" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/>` },
    { key: 'icon_heart', svg: `<path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>` },
    { key: 'icon_star', svg: `<polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>` },
    { key: 'icon_phone', svg: `<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>` },
    { key: 'icon_gift', svg: `<polyline points="20 12 20 22 4 22 4 12"/><rect width="20" height="5" x="2" y="7" rx="1"/><line x1="12" x2="12" y1="22" y2="7"/><path d="M12 7H7.5a2.5 2.5 0 0 1 0-5C11 2 12 7 12 7z"/><path d="M12 7h4.5a2.5 2.5 0 0 0 0-5C13 2 12 7 12 7z"/>` }
];

let targetIndex = -1;

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

function applyNoise(ctx, w, h) {
    ctx.save();
    for (let i = 0; i < 50; i++) {
        ctx.beginPath();
        ctx.fillStyle = `rgba(${getRandomInt(0, 255)}, ${getRandomInt(0, 255)}, ${getRandomInt(0, 255)}, 0.15)`;
        ctx.arc(getRandomInt(0, w), getRandomInt(0, h), getRandomInt(1, 4), 0, Math.PI * 2);
        ctx.fill();
    }
    ctx.restore();
}

function drawTargetText(text) {
    const canvas = document.getElementById('target-canvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const w = canvas.width;
    const h = canvas.height;

    ctx.clearRect(0, 0, w, h);

    applyNoise(ctx, w, h);

    ctx.save();
    ctx.translate(w / 2, h / 2);
    ctx.rotate((getRandomInt(-5, 5) * Math.PI) / 180);

    ctx.font = 'bold 24px "Poppins", sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';

    ctx.fillStyle = 'rgba(255, 0, 0, 0.4)';
    ctx.fillText(text, getRandomInt(-2, 2), getRandomInt(-2, 2));
    ctx.fillStyle = 'rgba(0, 255, 255, 0.4)';
    ctx.fillText(text, getRandomInt(-2, 2), getRandomInt(-2, 2));

    ctx.fillStyle = '#FFF';
    ctx.fillText(text, 0, 0);

    ctx.strokeStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.lineWidth = 1;
    for (let i = 0; i < 3; i++) {
        ctx.beginPath();
        ctx.moveTo(-50, getRandomInt(-10, 10));
        ctx.lineTo(50, getRandomInt(-10, 10));
        ctx.stroke();
    }

    ctx.restore();
}

function fuzzifySVG(pathData) {
    const noise = `M ${getRandomInt(-100, 100)} ${getRandomInt(-100, 100)} L ${getRandomInt(-100, 100)} ${getRandomInt(-100, 100)}Z`;
    return pathData + noise;
}

export const Verification = (event, globalTranslations) => {
    switch (event.data.action) {
        case 'open':
            if (globalTranslations) {
                if (globalTranslations.verif_title) $('#verification-title').text(globalTranslations.verif_title);
                if (globalTranslations.verif_desc) $('#verification-desc').text(globalTranslations.verif_desc);
            }
            generateVerification(globalTranslations);
            $('#verification-wrapper').css('display', 'flex');
            break;
        case 'close':
            $('#verification-wrapper').css('display', 'none');
            break;
    }
};

function generateVerification(globalTranslations) {
    const iconContainer = $('#verification-icons');
    iconContainer.empty();

    const selectedIcons = [];
    const availableIcons = [...icons];

    for (let i = 0; i < 6; i++) {
        const randomIndex = Math.floor(Math.random() * availableIcons.length);
        selectedIcons.push(availableIcons.splice(randomIndex, 1)[0]);
    }

    targetIndex = Math.floor(Math.random() * selectedIcons.length);
    const targetIcon = selectedIcons[targetIndex];

    const translatedName = (globalTranslations && globalTranslations[targetIcon.key]) ? globalTranslations[targetIcon.key] : targetIcon.key;

    drawTargetText(translatedName);

    const positions = [
        { l: 5, t: 5 }, { l: 38, t: 5 }, { l: 70, t: 5 },
        { l: 5, t: 55 }, { l: 38, t: 55 }, { l: 70, t: 55 }
    ];

    selectedIcons.forEach((icon, index) => {
        const pos = positions[index];
        const left = pos.l + getRandomInt(-2, 2);
        const top = pos.t + getRandomInt(-2, 2);
        const rotation = getRandomInt(-15, 15);

        const iconDiv = $(`
            <div class="verif-icon" style="left: ${left}%; top: ${top}%; transform: rotate(${rotation}deg);" data-index="${index}">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width: 70%; height: 70%;">
                    ${fuzzifySVG(icon.svg)}
                </svg>
                <div class="noise-overlay" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; opacity: 0.1;"></div>
            </div>
        `);

        iconDiv.on('click', () => {
            if (index === targetIndex) {
                $.post('https://hovers/verificationSuccess');
                $('#verification-wrapper').css('display', 'none');
            } else {
                $.post('https://hovers/verificationFailure');
                $('#verification-wrapper').css('display', 'none');
            }
        });

        iconContainer.append(iconDiv);
    });
}
