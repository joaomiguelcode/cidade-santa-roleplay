
window.locales = {};
window.ptLocales = {};
window.currentLocale = 'pt-br'; // Default
window.translationMap = {};
window.specialWhatsappNumbers = {};

window._L = function (key) {
    if (window.locales && window.locales[key]) {
        return window.locales[key];
    }
    return key;
};

window._TF = function (hours, minutes) {
    const format = window._L("UI_TIME_FORMAT");
    let h = parseInt(hours);
    let m = minutes.toString().padStart(2, '0');
    if (format === "12") {
        h = h % 12;
        h = h ? h : 12;
        return `${h}:${m}`;
    }
    return `${h.toString().padStart(2, '0')}:${m}`;
};

window._TH = function (hours) {
    const format = window._L("UI_TIME_FORMAT");
    let h = parseInt(hours);
    if (format === "12") {
        h = h % 12;
        h = h ? h : 12;
        return h.toString();
    }
    return h.toString().padStart(2, '0');
};

window._TM = function (minutes) {
    return minutes.toString().padStart(2, '0');
};

window._GM = function (monthIndex) {
    const months = [
        "UI_MONTH_JAN", "UI_MONTH_FEB", "UI_MONTH_MAR", "UI_MONTH_APR",
        "UI_MONTH_MAY", "UI_MONTH_JUN", "UI_MONTH_JUL", "UI_MONTH_AUG",
        "UI_MONTH_SEP", "UI_MONTH_OCT", "UI_MONTH_NOV", "UI_MONTH_DEC"
    ];
    return window._L(months[monthIndex]);
};

window._DF = function (day, month, year) {
    const format = window._L("UI_DATE_FORMAT");
    const m = window._GM(month);
    if (format === "US") {
        return `${m} ${day}, ${year}`;
    }
    if (format === "AR") {
        return `${day} من ${m} ${year}`;
    }
    // Default handles BR, PT, ES (X de Y de Z)
    return `${day} de ${m} de ${year}`;
};

window._GMU = function (monthIndex) {
    return window._GM(monthIndex).toUpperCase();
};

window._GMS = function (monthIndex) {
    return window._GM(monthIndex).substring(0, 3);
};

window._DF2 = function (day, month) {
    const format = window._L("UI_DATE_FORMAT");
    const m = window._GM(month);
    if (format === "US") {
        return `${m} ${day}`;
    }
    if (format === "AR") {
        return `${day} من ${m}`;
    }
    return `${day} de ${m}`;
};

window._DF2U = function (day, month) {
    const format = window._L("UI_DATE_FORMAT");
    const m = window._GMU(month);
    if (format === "US") {
        return `${m} ${day}`;
    }
    if (format === "AR") {
        return `${day} من ${m}`;
    }
    return `${day} DE ${m}`;
};

window.getDateLocale = function () {
    if (!window.currentLocale) return 'pt-BR';
    switch (window.currentLocale.toLowerCase()) {
        case 'en-us': return 'en-US';
        case 'es-es': return 'es-ES';
        case 'pt-pt': return 'pt-PT';
        case 'ar-sa': return 'ar-SA';
        default: return 'pt-BR';
    }
};

window.getWeekdays = function () {
    try {
        const locale = window.getDateLocale();
        // Sunday Jan 7 2024
        const days = [];
        for (let i = 0; i < 7; i++) {
            const d = new Date(2024, 0, 7 + i);
            days.push(d.toLocaleDateString(locale, { weekday: 'short' }).toLowerCase().replace('.', ''));
        }
        return days;
    } catch (e) {
        return ["dom", "seg", "ter", "qua", "qui", "sex", "sab"];
    }
};

window.getMonths = function () {
    try {
        const locale = window.getDateLocale();
        const months = [];
        for (let i = 0; i < 12; i++) {
            const d = new Date(2024, i, 1);
            months.push(d.toLocaleDateString(locale, { month: 'short' }).toLowerCase().replace('.', ''));
        }
        return months;
    } catch (e) {
        return ["jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"];
    }
};

/** BCP-47 style: trim, lower case, underscores → hyphens (e.g. pt_PT → pt-pt). */
function normalizeLocaleCode(raw) {
    if (raw == null) return '';
    const s = String(raw).trim().toLowerCase().replace(/_/g, '-');
    return s;
}

async function loadLocale(lang) {
    const code = normalizeLocaleCode(lang);
    if (!code) return false;
    try {
        const response = await fetch(`locale_${code}.json`);
        if (response.ok) {
            window.locales = await response.json();
            window.currentLocale = code;
            console.log(`Loaded locale: ${code}`);
            updateTranslationMap();
            return true;
        }
    } catch (e) {
        // Silent fail for fallback logic
    }
    return false;
}

async function loadReferenceLocale() {
    try {
        const response = await fetch(`locale_pt-br.json`);
        if (response.ok) {
            window.ptLocales = await response.json();
            updateTranslationMap();
        }
    } catch (e) { }
}

function updateTranslationMap() {
    window.translationMap = {};
    if (!window.ptLocales || !window.locales) return;

    for (const key in window.ptLocales) {
        const ptValue = window.ptLocales[key].trim();
        window.translationMap[ptValue] = window.locales[key];
    }
}

function uitrans(source) {
    const trimmed = source.trim();
    if (window.translationMap && window.translationMap[trimmed]) {
        return window.translationMap[trimmed];
    }
    // Texto no DOM é a própria chave (ex.: UI_POLICE) — translationMap só mapeia frases PT-BR
    if (window.locales && Object.prototype.hasOwnProperty.call(window.locales, trimmed)) {
        return window.locales[trimmed];
    }
    if (trimmed && window.currentLocale !== 'pt-br' && !window.locales[trimmed]) {
        console.log(`[Missing Translation] "${trimmed}"`);
    }
    return source;
}

function translate(node) {
    const source = node.textContent.trim();
    if (!source) return;

    const title = node.parentElement;
    const isChatListTitle = title?.matches('li h2.text-3xl.text-theme');
    const isChatHeaderTitle = title?.matches('[container] .bg-whatsapp h1.ml-28.font-bold');
    const isWhatsappNotificationTitle = title?.matches('.notifications li.notification h1')
        && title.closest('li')?.querySelector('img[src*="/whaats.png"]');

    if ((isWhatsappOpen() && (isChatListTitle || isChatHeaderTitle)) || isWhatsappNotificationTitle) {
        const contact = window.specialWhatsappNumbers[source];
        if (contact) {
            node.textContent = contact.name;
            const avatar = isChatListTitle
                ? title.closest('li')?.querySelector('img')
                : isChatHeaderTitle
                    ? title.closest('.bg-whatsapp')?.querySelector('img.w-12.rounded-full')
                    : null;
            if (avatar && contact.avatar) avatar.src = contact.avatar;
            if (isChatHeaderTitle) {
                const addContactButton = title.querySelector('i.fa-user-plus')?.closest('button');
                if (addContactButton) addContactButton.style.display = 'none';
            }
            return;
        }
    }

    const translated = uitrans(source);
    if (translated !== source) {
        node.textContent = node.textContent.replace(source, translated);
    }
}

function deepTranslate(node) {
    if (!node) return;
    node.childNodes.forEach(child => {
        if (child instanceof Text) {
            translate(child);
        } else {
            deepTranslate(child);
        }
    });
}

let specialContactsPending = false;
let specialContactsLoaded = false;

function isWhatsappOpen() {
    const root = document.getElementById('root');
    return Boolean(root?.querySelector('.bg-whatsapp-dark'));
}

function hasWhatsappNotification() {
    return Boolean(document.querySelector('.notifications li.notification img[src*="/whaats.png"]'));
}

async function syncSpecialWhatsappContacts() {
    if (!isWhatsappOpen() && !hasWhatsappNotification()) {
        return;
    }

    if (specialContactsLoaded || specialContactsPending) return;
    specialContactsPending = true;

    try {
        const response = await fetch('https://player/getSpecialNumbers', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: '{}',
        });
        if (!response.ok) return;

        const names = await response.json();
        if (!isWhatsappOpen() && !hasWhatsappNotification()) return;

        window.specialWhatsappNumbers = names;
        specialContactsLoaded = true;
        deepTranslate(document.getElementById('root'));
    } catch (error) {
        console.warn('Could not load special WhatsApp contacts', error);
    } finally {
        specialContactsPending = false;
    }
}

const observer = new MutationObserver(mutations => {
    for (const record of mutations) {
        deepTranslate(record.target);
    }
    void syncSpecialWhatsappContacts();
});

const startObserver = () => {
    const target = document.getElementById('root') || document.body;
    if (target) {
        observer.observe(target, {
            subtree: true,
            childList: true,
        });
        deepTranslate(target);
        void syncSpecialWhatsappContacts();
    } else {
        setTimeout(startObserver, 100);
    }
};

window.addEventListener('message', async (event) => {
    if (event.data.type === 'setLocale') {
        const raw = event.data.lang;
        if (typeof raw !== 'string' || !String(raw).trim()) return;

        const fullLang = normalizeLocaleCode(raw);
        const shortLang = fullLang.split('-')[0];

        console.log(`Setting locale to: ${fullLang}`);

        // Try exact match first (e.g., pt-br, pt-pt; also fixes pt_PT → locale_pt-pt.json)
        let loaded = await loadLocale(fullLang);

        // Fallback to short version if failed (e.g., en-gb → en)
        if (!loaded && fullLang !== shortLang) {
            loaded = await loadLocale(shortLang);
        }

        if (!loaded && shortLang === 'es') {
            loaded = await loadLocale('es-es');
        }

        // Só existe locale_pt-br / locale_pt-pt, não locale_pt.json
        if (!loaded && shortLang === 'pt') {
            loaded = await loadLocale('pt-br');
        }

        if (!loaded && fullLang !== 'pt-br' && shortLang !== 'pt') {
            await loadLocale('pt-br');
        }
    }
});

// Initial load
const systemLang = normalizeLocaleCode(navigator.language || 'pt-br');
loadLocale(systemLang).then(loaded => {
    if (!loaded) loadLocale('pt-br');
});
loadReferenceLocale();
startObserver();
