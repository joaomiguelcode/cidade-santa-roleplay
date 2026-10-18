
window.locales = {};
window.ptLocales = {};
window.currentLocale = 'pt-br';
window.translationMap = {};

window._L = function (key) {
    if (window.locales && window.locales[key]) {
        return window.locales[key];
    }
    return key;
};

window.getDateLocale = function () {
    if (!window.currentLocale) return 'pt-BR';
    switch (window.currentLocale.toLowerCase()) {
        case 'en-us': return 'en-US';
        case 'es-es': return 'es-ES';
        case 'pt-pt': return 'pt-PT';
        case 'fr-fr': return 'fr-FR';
        case 'ar-sa': return 'ar-SA';
        default: return 'pt-BR';
    }
};

async function loadLocale(lang) {
    try {
        const response = await fetch(`locale_${lang}.json`);
        if (response.ok) {
            window.locales = await response.json();
            window.currentLocale = lang;
            updateTranslationMap();
            translateNode(document.body);
            return true;
        }
    } catch (e) { }
    return false;
}

async function loadReferenceLocale() {
    try {
        const response = await fetch(`locale_pt-br.json`);
        if (response.ok) {
            window.ptLocales = await response.json();
            updateTranslationMap();
            translateNode(document.body);
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
    if (!source || typeof source !== 'string') return source;
    const trimmed = source.trim();
    if (!trimmed) return source;

    if (window.translationMap && window.translationMap[trimmed]) {
        return window.translationMap[trimmed];
    }

    // Prefix handling (safe version)
    if (source.includes(' • ')) {
        const parts = source.split(' • ');
        const prefix = parts[0].trim();
        if (window.translationMap && window.translationMap[prefix]) {
            return window.translationMap[prefix] + ' • ' + parts.slice(1).join(' • ');
        }
    }
    return source;
}

function translateAttribute(node, attrName) {
    if (!node || !node.getAttribute) return;
    const attr = node.getAttribute(attrName);
    if (!attr) return;
    const translated = uitrans(attr);
    if (translated !== attr) {
        node.setAttribute(attrName, translated);
    }
}

function translateNode(node) {
    if (!node) return;

    if (node.nodeType === 3) { // Text Node
        const source = node.textContent.trim();
        if (!source) return;
        const translated = uitrans(source);
        if (translated !== source) {
            // Prevent recursive updates by checking if already translated
            const parent = node.parentElement;
            if (parent && parent.dataset.translated === source) return;

            node.textContent = node.textContent.replace(source, translated);
            if (parent) parent.dataset.translated = source;
        }
    } else if (node.nodeType === 1) { // Element
        translateAttribute(node, 'placeholder');
        translateAttribute(node, 'title');

        // Skip certain elements
        if (node.tagName === 'SCRIPT' || node.tagName === 'STYLE') return;

        for (let i = 0; i < node.childNodes.length; i++) {
            translateNode(node.childNodes[i]);
        }
    }
}

// Safer observer - NO characterData observation to prevent loops with Svelte
const observer = new MutationObserver(mutations => {
    for (const record of mutations) {
        if (record.type === 'childList') {
            record.addedNodes.forEach(node => {
                if (node.nodeType === 1 || node.nodeType === 3) {
                    translateNode(node);
                }
            });
        }
    }
});

const startObserver = () => {
    const target = document.body;
    if (target) {
        observer.observe(target, {
            subtree: true,
            childList: true,
            characterData: false // DANGEROUS - Set to false
        });
        translateNode(target);
    } else {
        setTimeout(startObserver, 100);
    }
};

window.addEventListener('message', async (event) => {
    if (event.data.type === 'setLocale') {
        const fullLang = event.data.lang?.toLowerCase() || 'pt-br';
        const shortLang = fullLang.split('-')[0];
        let loaded = await loadLocale(fullLang);
        if (!loaded && fullLang !== shortLang) loaded = await loadLocale(shortLang);
        if (!loaded && shortLang === 'es') loaded = await loadLocale('es-es');
        if (!loaded && shortLang === 'fr') loaded = await loadLocale('fr-fr');
        if (!loaded && shortLang === 'ar') loaded = await loadLocale('ar-sa');
        if (!loaded && fullLang !== 'pt-br' && shortLang !== 'pt') loadLocale('pt-br');
    }
});

loadReferenceLocale();
const systemLang = (navigator.language || 'pt-br').toLowerCase();
loadLocale(systemLang).then(loaded => { if (!loaded) loadLocale('pt-br'); });
startObserver();
