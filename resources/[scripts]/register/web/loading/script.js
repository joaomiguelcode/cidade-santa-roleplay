/**
 * Santa Group Loading Screen - Main Application
 * Clean Code Implementation with Modern JavaScript
 * 
 * 🎯 DUMPOU? GOSTOU? QUER ALGO DO CRIADOR DO MESMO? 
 * 👨‍💻 CRIADO POR: tadalas
 * 🔗 DISCORD: https://discord.gg/gCZpDV8GvS
 * 
 * ⚠️ ATENÇÃO DUMPERS: Este código está protegido!
 * 🏢 SISTEMA EXCLUSIVO DA SANTA GROUP - USO PROIBIDO FORA DA REDE
 * Se você está tentando roubar ou modificar este sistema, 
 * saiba que suas ações são ilegais e serão rastreadas.
 * Entre em contato no Discord se quiser usar legalmente criando um proprio.
 */

// ===== CONFIGURATION =====
// 🎯 Configurações principais do sistema - tadalas @ https://discord.gg/gCZpDV8GvS
const CONFIG = {
    DEFAULT_VOLUME: 0.05,
    CACHE_DURATION: 86400000, // 24 hours
    VIDEO_LOAD_TIMEOUT: 8000,
    MAX_VIDEO_ATTEMPTS: 3,
    RETRY_INTERVAL: 500,
    MAX_RETRIES: 3
};

// ===== UTILITY FUNCTIONS =====
// 🚀 Classe de utilitários - Desenvolvido por tadalas @ https://discord.gg/gCZpDV8GvS
class Utils {
    /**
     * Format seconds as MM:SS time string
     * @param {number} seconds - Time in seconds
     * @returns {string} Formatted time string
     */
    static formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return `${minutes}:${secs.toString().padStart(2, '0')}`;
    }

    /**
     * Create and dispatch custom event
     * @param {Element} element - Target element
     * @param {string} eventType - Event type
     */
    static fireEvent(element, eventType) {
        if (!element) return;

        if (element.fireEvent) {
            element.fireEvent(`on${eventType}`);
        } else {
            const event = new Event(eventType, { bubbles: true, cancelable: true });
            element.dispatchEvent(event);
        }
    }

    /**
     * Debounce function calls
     * @param {Function} func - Function to debounce
     * @param {number} wait - Wait time in ms
     * @returns {Function} Debounced function
     */
    static debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    /**
     * Check if element exists in DOM
     * @param {string} selector - CSS selector
     * @returns {Element|null} Found element or null
     */
    static getElement(selector) {
        return document.querySelector(selector);
    }

    /**
     * Get all elements matching selector
     * @param {string} selector - CSS selector
     * @returns {NodeList} Found elements
     */
    static getElements(selector) {
        return document.querySelectorAll(selector);
    }
}

// ===== CACHE MANAGER =====
// 💾 Sistema de cache inteligente - tadalas @ https://discord.gg/gCZpDV8GvS
class CacheManager {
    constructor() {
        this.cache = {
            translations: null,
            songs: {},
            images: {}
        };
    }

    /**
     * Get cached translations from localStorage
     * @returns {Object|null} Cached translations or null
     */
    getCachedTranslations() {
        try {
            const cachedData = localStorage.getItem('vrp_translations');
            if (!cachedData) return null;

            const parsedData = JSON.parse(cachedData);
            if (!parsedData?.timestamp) return null;

            const now = Date.now();
            if (now - parsedData.timestamp < CONFIG.CACHE_DURATION) {
                console.log('Using cached translations');
                return parsedData.data;
            }
        } catch (error) {
            console.error('Error reading cached translations:', error);
        }
        return null;
    }

    /**
     * Cache translations in localStorage
     * @param {Object} data - Translation data
     */
    cacheTranslations(data) {
        try {
            const cacheData = {
                timestamp: Date.now(),
                data: data
            };
            localStorage.setItem('vrp_translations', JSON.stringify(cacheData));
            console.log('Translations cached successfully');
        } catch (error) {
            console.error('Error caching translations:', error);
        }
    }

    /**
     * Check if image is cached
     * @param {string} url - Image URL
     * @returns {boolean} True if cached
     */
    isImageCached(url) {
        return !!this.cache.images[url];
    }

    /**
     * Mark image as cached
     * @param {string} url - Image URL
     */
    cacheImage(url) {
        this.cache.images[url] = true;
    }
}

// ===== TRANSLATION MANAGER =====
// 🌍 Gerenciador de traduções multilíngue - tadalas @ https://discord.gg/gCZpDV8GvS
class TranslationManager {
    constructor() {
        this.translations = {};
        this.cacheManager = new CacheManager();
    }

    /**
     * Get default translations for city
     * @param {string} cityName - City name
     * @returns {Object} Default translations
     */
    getDefaultTranslations(cityName) {
        const defaultTranslations = {
            kingdom: {
                textContent: {}
            },
            district99: {
                textContent: {}
            },
            krown: {
                textContent: {}
            },
            orizon: {
                textContent: {}
            },
            liberty99: {
                textContent: {}
            },
            boomerang: {
                textContent: {}
            },
            malta: {
                textContent: {}
            },
            real: {
                textContent: {}
            },
            default: {
                textContent: {}
            }
        };

        const lowerCityName = cityName?.toLowerCase() || 'default';
        return defaultTranslations[lowerCityName] || defaultTranslations.default;
    }

    /**
     * Load translations from server or cache
     * @returns {Promise<Object>} Translation data
     */
    async loadTranslations() {
        // Try cache first
        const cachedTranslations = this.cacheManager.getCachedTranslations();
        if (cachedTranslations) {
            this.translations = cachedTranslations;
            return cachedTranslations;
        }

        try {
            const response = await fetch('http://localization/getLang', {
                method: 'POST',
                body: JSON.stringify({ resourceName: 'vrp' })
            });

            const data = await response.json();
            this.translations = data;
            this.cacheManager.cacheTranslations(data);
            return data;
        } catch (error) {
            const cityName = window.nuiHandoverData?.cityName;
            this.translations = this.getDefaultTranslations(cityName);
            return this.translations;
        }
    }

    /**
     * Update translated elements in DOM
     */
    updateTranslatedElements() {
        const cityName = window.nuiHandoverData?.cityName;

        if (!this.translations?.textContent) {
            console.warn('Translations missing, using defaults');
            this.translations = this.getDefaultTranslations(cityName);
        }

        // No age classification elements to update
        console.log('Translations updated successfully');
    }
}

// ===== ASSET LOADER =====
// 📁 Carregador de assets otimizado - tadalas @ https://discord.gg/gCZpDV8GvS
class AssetLoader {
    constructor() {
        this.cacheManager = new CacheManager();
    }

    /**
     * Preload image with caching
     * @param {string} url - Image URL
     * @returns {Promise<void>} Promise that resolves when image is loaded
     */
    preloadImage(url) {
        return new Promise((resolve, reject) => {
            if (this.cacheManager.isImageCached(url)) {
                console.log('Using cached image:', url);
                resolve();
                return;
            }

            const img = new Image();
            img.onload = () => {
                console.log('Image loaded:', url);
                this.cacheManager.cacheImage(url);
                resolve();
            };
            img.onerror = () => {
                console.error('Error loading image:', url);
                reject(new Error(`Failed to load image: ${url}`));
            };
            img.src = url;
        });
    }

    /**
     * Load multiple images
     * @param {string[]} urls - Array of image URLs
     * @returns {Promise<void[]>} Promise that resolves when all images are loaded
     */
    async loadImages(urls) {
        return Promise.allSettled(urls.map(url => this.preloadImage(url)));
    }
}

// ===== VIP SLIDER =====
// 🎨 Slider VIP com animações suaves - tadalas @ https://discord.gg/gCZpDV8GvS
class VIPSlider {
    constructor() {
        this.sliderTrack = Utils.getElement('#sliderTrack');
        this.paginationDots = Utils.getElement('#paginationDots');
        this.cardTitle = Utils.getElement('#cardTitle');
        this.cardDescription = Utils.getElement('#cardDescription');
        this.currentSlide = 0;
        this.slides = [];
        this.slidesData = []; // Armazena os dados completos de cada slide (title, description, etc.)
        this.autoPlayInterval = null;
        this.autoPlayDelay = 10000; // 10 seconds

        this.init();
    }

    /**
     * Initialize VIP slider
     */
    init() {
        // Don't setup default slides if we're using cityConfig slides
        // setupSlides will only be called if no slides are configured via cityConfigManager
        if (!window.cityConfigManager || !window.nuiHandoverData?.cityName) {
            this.setupSlides();
        } else {
            console.log('Skipping default setupSlides - will use cityConfig slides');
        }
        this.createPaginationDots();
        this.bindEvents();

        // Only start autoplay if we have slides (from setupSlides or cityConfig)
        if (this.slides.length > 0) {
            this.startAutoPlay();
        }
    }

    /**
     * Setup slides with city banners (fallback/default slides)
     */
    setupSlides() {
        const cities = ['Santa', 'Kingdom', 'Maresia', 'District99', 'Krown', 'Orizon', 'Liberty99'];

        cities.forEach((city, index) => {
            const slide = document.createElement('div');
            slide.className = 'slider-slide';
            slide.dataset.index = index;

            const img = document.createElement('img');
            img.src = `https://santaloading.roleplayrp.com/img/newloading/${city}/banner_cd.png`;
            img.alt = `${city} VIP Banner`;
            img.onerror = () => {
                console.warn(`Failed to load banner for city: ${city}`);
                // Fallback to a default image or hide the slide
                slide.style.display = 'none';
            };

            // Add a subtle overlay for better text readability
            const overlay = document.createElement('div');
            overlay.className = 'slider-overlay';

            slide.appendChild(img);
            slide.appendChild(overlay);
            this.sliderTrack.appendChild(slide);
            this.slides.push(slide);

            // Debug: Log when image loads
            img.onload = () => {
                console.log(`Image loaded successfully for city: ${city}`);
            };
        });
    }

    /**
     * Create pagination dots
     */
    createPaginationDots() {
        this.paginationDots.innerHTML = '';

        this.slides.forEach((_, index) => {
            const dot = document.createElement('span');
            dot.className = `dot ${index === 0 ? 'active' : ''}`;
            dot.dataset.index = index;
            dot.addEventListener('click', () => this.goToSlide(index, true)); // true = manual change
            this.paginationDots.appendChild(dot);
        });
    }

    /**
     * Bind slider events
     */
    bindEvents() {
        // Pause auto-play on hover
        this.sliderTrack.addEventListener('mouseenter', () => this.stopAutoPlay());
        this.sliderTrack.addEventListener('mouseleave', () => this.startAutoPlay());
    }

    /**
     * Go to specific slide
     * @param {number} index - Slide index
     * @param {boolean} isManualChange - Whether this is a manual change (button click)
     */
    goToSlide(index, isManualChange = false) {
        if (index < 0 || index >= this.slides.length) return;

        this.currentSlide = index;
        this.updateSliderPosition();
        this.updatePaginationDots();
        this.updateSlideContent();

        // If this is a manual change (button click), restart autoplay to reset the 10-second timer
        if (isManualChange) {
            this.startAutoPlay();
        }
    }

    /**
     * Update slider position
     */
    updateSliderPosition() {
        const translateX = -this.currentSlide * 100;
        this.sliderTrack.style.transform = `translateX(${translateX}%)`;
    }

    /**
     * Update pagination dots
     */
    updatePaginationDots() {
        const dots = this.paginationDots.querySelectorAll('.dot');
        dots.forEach((dot, index) => {
            dot.classList.toggle('active', index === this.currentSlide);
        });
    }

    /**
     * Update slide title and description
     */
    updateSlideContent() {
        const slideData = this.slidesData[this.currentSlide];
        if (!slideData) return;

        if (this.cardTitle && slideData.title) {
            this.cardTitle.textContent = slideData.title;
        }

        if (this.cardDescription && slideData.description) {
            this.cardDescription.innerHTML = slideData.description;
        }
    }

    /**
     * Go to next slide
     * @param {boolean} isAutoPlay - Whether this is from autoplay (not manual)
     */
    nextSlide(isAutoPlay = false) {
        const nextIndex = (this.currentSlide + 1) % this.slides.length;
        this.goToSlide(nextIndex, !isAutoPlay);
    }

    /**
     * Go to previous slide
     */
    prevSlide() {
        const prevIndex = this.currentSlide === 0 ? this.slides.length - 1 : this.currentSlide - 1;
        this.goToSlide(prevIndex, true);
    }

    /**
     * Start auto-play
     */
    startAutoPlay() {
        this.stopAutoPlay();
        this.autoPlayInterval = setInterval(() => {
            this.nextSlide(true); // Pass true to indicate this is autoplay, not manual
        }, this.autoPlayDelay);
    }

    /**
     * Stop auto-play
     */
    stopAutoPlay() {
        if (this.autoPlayInterval) {
            clearInterval(this.autoPlayInterval);
            this.autoPlayInterval = null;
        }
    }

    /**
     * Destroy slider
     */
    destroy() {
        this.stopAutoPlay();
        this.sliderTrack.innerHTML = '';
        this.paginationDots.innerHTML = '';
        this.slides = [];
        this.slidesData = [];
        this.currentSlide = 0;
    }
}

// ===== VIRTUAL KEYBOARD =====
// ⌨️ Teclado virtual interativo - tadalas @ https://discord.gg/gCZpDV8GvS
class VirtualKeyboard {
    constructor(containerId) {
        console.log('VirtualKeyboard constructor called with:', containerId);
        this.container = Utils.getElement(containerId);
        console.log('Container element found:', this.container);
        this.activeKeys = new Set();
        this.keyboardLayout = this.getKeyboardLayout();
        this.init();
    }

    /**
     * Get keyboard layout configuration
     * @returns {Array} Keyboard layout
     */
    getKeyboardLayout() {
        return [
            // Number row
            ['`~', '!1', '@2', '#3', '$4', '%5', '^6', '&7', '*8', '(9', ')0', '-_', '+=', 'backspace'],
            // First letter row
            ['tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[{', ']}', '|\\'],
            // Second letter row
            ['caps lock', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';:', '\'"', 'enter'],
            // Third letter row
            ['shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',<', '.>', '/?', 'shift'],
            // Bottom row
            ['ctrl', 'win', 'alt', 'space', 'alt', 'win', 'del', 'ctrl']
        ];
    }


    /**
     * Get highlighted keys based on the design image
     * @returns {Array} Array of highlighted key names
     */
    getHighlightedKeys() {
        return ['esc', 'f5', 'tab', 'caps lock', 'r', 't', 'p', 'k', 'home'];
    }

    /**
     * Initialize virtual keyboard
     */
    init() {
        if (!this.container) {
            return;
        }

        console.log('Clearing container and building keyboard...');
        this.container.innerHTML = '';

        // Build keyboard in straight lines
        this.keyboardLayout.forEach((row, rowIndex) => {
            const rowElement = document.createElement('div');
            rowElement.className = 'keyboard-row';

            row.forEach(key => {
                const keyElement = this.createKeyElement(key);
                rowElement.appendChild(keyElement);
            });

            this.container.appendChild(rowElement);
        });

        console.log('Keyboard built, binding events...');
        this.bindEvents();
        console.log('VirtualKeyboard initialization complete');
    }

    /**
     * Create individual key element
     * @param {string} keyText - Key text
     * @returns {HTMLElement} Key element
     */
    createKeyElement(keyText) {
        const keyElement = document.createElement('div');
        keyElement.className = 'key';
        keyElement.textContent = keyText;
        keyElement.dataset.key = keyText;

        // Add highlighted class for specific keys from the design
        const highlightedKeys = this.getHighlightedKeys();
        if (highlightedKeys.includes(keyText)) {
            keyElement.classList.add('highlighted');
        }

        // Add special classes for different key types
        if (keyText === 'space') {
            keyElement.classList.add('space');
        } else if (['tab', 'caps lock', 'ctrl', 'alt', 'win', 'del'].includes(keyText)) {
            keyElement.classList.add('wide');
        } else if (keyText === 'backspace' || keyText === 'enter' || keyText === 'shift') {
            keyElement.classList.add('extra-wide');
        }

        return keyElement;
    }

    /**
     * Bind keyboard events
     */
    bindEvents() {
        const keys = this.container.querySelectorAll('.key');

        keys.forEach(key => {
            key.addEventListener('click', () => this.handleKeyClick(key));
            key.addEventListener('mousedown', () => this.activateKey(key));
            key.addEventListener('mouseup', () => this.deactivateKey(key));
            key.addEventListener('mouseleave', () => this.deactivateKey(key));
        });

        // Bind real keyboard events
        document.addEventListener('keydown', (e) => this.handleRealKeyDown(e));
        document.addEventListener('keyup', (e) => this.handleRealKeyUp(e));
    }

    /**
     * Handle virtual key click
     * @param {HTMLElement} keyElement - Clicked key element
     */
    handleKeyClick(keyElement) {
        const keyText = keyElement.dataset.key;
        console.log('Virtual key clicked:', keyText);

        // Simulate key press
        this.activateKey(keyElement);
        setTimeout(() => this.deactivateKey(keyElement), 150);
    }

    /**
     * Handle real keyboard key down
     * @param {KeyboardEvent} event - Keyboard event
     */
    handleRealKeyDown(event) {
        const keyText = this.getKeyText(event);
        const virtualKey = this.container.querySelector(`[data-key="${keyText}"]`);

        if (virtualKey) {
            this.activateKey(virtualKey);
        }
    }

    /**
     * Handle real keyboard key up
     * @param {KeyboardEvent} event - Keyboard event
     */
    handleRealKeyUp(event) {
        const keyText = this.getKeyText(event);
        const virtualKey = this.container.querySelector(`[data-key="${keyText}"]`);

        if (virtualKey) {
            this.deactivateKey(virtualKey);
        }
    }

    /**
     * Get key text from keyboard event
     * @param {KeyboardEvent} event - Keyboard event
     * @returns {string} Key text
     */
    getKeyText(event) {
        const key = event.key.toLowerCase();

        // Map special keys
        const keyMap = {
            ' ': 'space',
            'backspace': 'backspace',
            'enter': 'enter',
            'tab': 'tab',
            'capslock': 'caps lock',
            'shift': 'shift',
            'control': 'ctrl',
            'alt': 'alt',
            'meta': 'win',
            'delete': 'del'
        };

        return keyMap[key] || key;
    }

    /**
     * Activate key visual state
     * @param {HTMLElement} keyElement - Key element
     */
    activateKey(keyElement) {
        if (!keyElement) return;

        keyElement.classList.add('active');
        this.activeKeys.add(keyElement.dataset.key);
    }

    /**
     * Deactivate key visual state
     * @param {HTMLElement} keyElement - Key element
     */
    deactivateKey(keyElement) {
        if (!keyElement) return;

        keyElement.classList.remove('active');
        this.activeKeys.delete(keyElement.dataset.key);
    }

    /**
     * Highlight random keys for demo - DISABLED
     */
    highlightRandomKeys() {
        // Animation disabled - no random key highlighting
        console.log('VirtualKeyboard: Random key highlighting is disabled');
        return;
    }
}

// ===== MUSIC PLAYER =====
// 🎵 Player de música com controles avançados - tadalas @ https://discord.gg/gCZpDV8GvS
class MusicPlayer {
    constructor() {
        this.audio = Utils.getElement('#backgroundMusic');
        this.currentTrack = 0;
        this.playlist = [];
        this.isPlaying = false;
        // Try to get current volume from audio element if already set by backend, otherwise use default
        // HTML5 audio default volume is 1.0, so if it's not 1.0, backend likely already set it
        if (this.audio && this.audio.volume !== 1.0 && !isNaN(this.audio.volume)) {
            this.volume = this.audio.volume;
        } else {
            this.volume = CONFIG.DEFAULT_VOLUME;
            // Ensure audio element has the correct volume
            if (this.audio) {
                this.audio.volume = this.volume;
            }
        }

        // Initialize volume slider visually at 50% (real volume unchanged)
        if (window.updateVolumeSlider) {
            window.updateVolumeSlider(50);
        }

        this.init();
    }

    /**
     * Initialize music player
     */
    init() {
        if (!this.audio) return;

        // Show skeleton while loading
        this.showMusicSkeleton();

        this.bindEvents();
        this.setupPlaylist();
    }

    /**
     * Setup playlist based on city
     */
    setupPlaylist() {
        const cityName = window.nuiHandoverData?.cityName;
        if (!cityName) return;

        // Get audio URL from city config manager if available
        let songUrl = null;
        if (window.cityConfigManager) {
            songUrl = window.cityConfigManager.getAudioUrl(cityName);
        }

        // Fallback to default URL construction
        if (!songUrl) {
            songUrl = `https://santaloading.roleplayrp.com/img/newloading/${cityName}/song.mp3`;
        }

        const imageUrl = `https://santaloading.roleplayrp.com/img/newloading/${cityName}/banner_cd.png`;

        this.playlist = [{
            song: cityName,
            image: imageUrl,
            mp3: songUrl
        }];

        this.currentTrack = 0;
        this.loadTrack(0);
    }

    /**
     * Update music from city configuration
     * This is called when city config is applied to prevent duplicate loading
     * @param {string} cityName - Name of the city
     * @param {string} audioUrl - Audio URL from config
     */
    updateMusicFromConfig(cityName, audioUrl) {
        // Check if audio is already loaded with the same URL
        const currentSrc = this.audio.src || (this.audio.querySelector('source')?.src);
        if (currentSrc && currentSrc === audioUrl) {
            console.log('Music already has the same URL:', audioUrl);
            // If loaded but not playing, try to play
            if (this.audio.paused || !this.isPlaying) {
                console.log('Music is paused, attempting to start playback');
                this.tryAutoPlay();
            }
            return;
        }

        // Check if playlist already matches
        if (this.playlist && this.playlist.length > 0 &&
            this.playlist[0].song === cityName && this.playlist[0].mp3 === audioUrl) {
            console.log('Playlist already matches city config');
            // If loaded but not playing, try to play
            if (this.audio.paused || !this.isPlaying) {
                console.log('Music is paused, attempting to start playback');
                this.tryAutoPlay();
            }
            return;
        }

        console.log('Updating music from city config:', cityName, audioUrl);

        // Show skeleton while loading new music
        this.showMusicSkeleton();

        // Update playlist with new URL
        const imageUrl = `https://santaloading.roleplayrp.com/img/newloading/${cityName}/banner_cd.png`;
        this.playlist = [{
            song: cityName,
            image: imageUrl,
            mp3: audioUrl
        }];

        this.currentTrack = 0;
        this.loadTrack(0);
    }


    /**
     * Bind audio events
     */
    bindEvents() {
        if (!this.audio) {
            console.warn('MusicPlayer: Audio element not found');
            return;
        }

        this.audio.addEventListener('timeupdate', () => this.updateProgress());
        this.audio.addEventListener('ended', () => this.onTrackEnded());
        this.audio.addEventListener('canplay', () => this.onCanPlay());
        this.audio.addEventListener('error', () => this.onError());

        // Bind control buttons
        const playPauseBtn = Utils.getElement('#playPause');
        const prevBtn = Utils.getElement('#prevTrack'); // Seek backward 10s
        const nextBtn = Utils.getElement('#nextTrack'); // Seek forward 10s

        // Force transparent background for play-pause button - never blue
        if (playPauseBtn) {
            playPauseBtn.style.background = 'transparent';
            playPauseBtn.style.backgroundColor = 'transparent';
            playPauseBtn.addEventListener('click', () => this.togglePlayPause());
            // Monitor for any background changes and force transparent
            const observer = new MutationObserver(() => {
                if (playPauseBtn.style.background !== 'transparent' && playPauseBtn.style.background !== '') {
                    playPauseBtn.style.background = 'transparent';
                    playPauseBtn.style.backgroundColor = 'transparent';
                }
            });
            observer.observe(playPauseBtn, { attributes: true, attributeFilter: ['style', 'class'] });
        }
        if (prevBtn) prevBtn.addEventListener('click', () => this.previousTrack());
        if (nextBtn) nextBtn.addEventListener('click', () => this.nextTrack());
    }

    /**
     * Load track by index
     * @param {number} index - Track index
     */
    loadTrack(index) {
        if (!this.playlist || !this.playlist[index]) return;

        const track = this.playlist[index];

        // Check if track is already loaded and playing to prevent duplicate loading
        const currentSrc = this.audio.src || (this.audio.querySelector('source')?.src);
        if (currentSrc && currentSrc === track.mp3) {
            // If already loaded and playing, don't reload
            if (!this.audio.paused && this.isPlaying && this.audio.readyState >= 2) {
                console.log('Track already loaded and playing, skipping duplicate load:', track.mp3);
                return;
            }
            // If loaded but not playing, just play it
            if (this.audio.readyState >= 2) {
                console.log('Track already loaded but not playing, starting playback:', track.mp3);
                this.updateTrackInfo(track);
                this.tryAutoPlay();
                return;
            }
        }

        this.audio.src = track.mp3;
        this.audio.volume = this.volume;

        // Update volume slider visually at 50% (real volume unchanged)
        if (window.updateVolumeSlider) {
            window.updateVolumeSlider(50);
        }

        // Update UI
        this.updateTrackInfo(track);
        this.audio.load();

        // Auto-play when audio is ready
        this.tryAutoPlay();
    }

    /**
     * Try to auto-play the audio
     */
    tryAutoPlay() {
        const tryPlay = () => {
            // Double check audio is not already playing
            if (!this.audio.paused && this.isPlaying) {
                console.log('Audio already playing, skipping autoplay');
                return;
            }

            this.audio.play().then(() => {
                this.isPlaying = true;
                this.updatePlayButton();
                console.log('Music started with autoplay');
            }).catch(error => {
                console.warn('Autoplay prevented, user interaction required:', error);
            });
        };

        // Try to play immediately if ready, or wait for canplay event
        if (this.audio.readyState >= 2) { // HAVE_CURRENT_DATA
            tryPlay();
        } else {
            // Use both canplay and loadeddata events for better compatibility
            const onReady = () => {
                tryPlay();
                this.audio.removeEventListener('loadeddata', onReady);
                this.audio.removeEventListener('canplay', onReady);
            };
            this.audio.addEventListener('loadeddata', onReady, { once: true });
            this.audio.addEventListener('canplay', onReady, { once: true });
        }
    }

    /**
     * Update track information in UI
     * @param {Object} track - Track object
     */
    updateTrackInfo(track) {
        const trackTitle = Utils.getElement('#trackTitle');
        const trackArtist = Utils.getElement('#trackArtist');
        const albumArt = Utils.getElement('#albumArt');

        if (trackTitle) trackTitle.textContent = track.song;

        // Get track artist from city configuration
        if (trackArtist) {
            const cityName = window.nuiHandoverData?.cityName;
            if (cityName && window.cityConfigManager) {
                const artistName = window.cityConfigManager.getTrackArtist(cityName);
                trackArtist.textContent = artistName;
            } else {
                trackArtist.textContent = 'Santa Group';
            }
        }
        if (albumArt) {
            // Wait for image to load before hiding skeleton
            albumArt.onload = () => {
                this.hideMusicSkeleton();
            };
            albumArt.onerror = () => {
                // Even if image fails, hide skeleton after a delay
                setTimeout(() => this.hideMusicSkeleton(), 500);
            };
            albumArt.src = track.image;

            // If image is already loaded (cached), hide skeleton immediately
            if (albumArt.complete && albumArt.naturalHeight !== 0) {
                this.hideMusicSkeleton();
            }
        } else {
            // If no album art element, hide skeleton anyway
            this.hideMusicSkeleton();
        }
    }

    /**
     * Hide music skeleton loader and show actual content
     */
    hideMusicSkeleton() {
        const skeleton = Utils.getElement('#musicSkeleton');
        const content = Utils.getElement('#musicContent');

        if (skeleton) {
            skeleton.classList.add('skeleton-hidden');
        }
        if (content) {
            content.classList.remove('skeleton-hidden');
        }
    }

    /**
     * Show music skeleton loader and hide actual content
     */
    showMusicSkeleton() {
        const skeleton = Utils.getElement('#musicSkeleton');
        const content = Utils.getElement('#musicContent');

        if (skeleton) {
            skeleton.classList.remove('skeleton-hidden');
        }
        if (content) {
            content.classList.add('skeleton-hidden');
        }
    }

    /**
     * Toggle play/pause
     */
    togglePlayPause() {
        if (this.isPlaying) {
            this.pause();
        } else {
            this.play();
        }
    }

    /**
     * Play current track
     */
    play() {
        if (!this.audio) return;

        this.audio.play().then(() => {
            this.isPlaying = true;
            this.updatePlayButton();
        }).catch(error => {
            console.error('Error playing audio:', error);
        });
    }

    /**
     * Pause current track
     */
    pause() {
        if (!this.audio) return;

        this.audio.pause();
        this.isPlaying = false;
        this.updatePlayButton();
    }

    /**
     * Seek forward in current track (10 seconds)
     */
    nextTrack() {
        if (!this.audio || !this.audio.duration) return;

        const seekAmount = 10; // 10 seconds forward
        const newTime = Math.min(this.audio.currentTime + seekAmount, this.audio.duration);

        console.log(`Seeking forward to ${newTime}s`);
        this.audio.currentTime = newTime;
        this.updateProgress();
    }

    /**
     * Seek backward in current track (10 seconds)
     */
    previousTrack() {
        if (!this.audio || !this.audio.duration) return;

        const seekAmount = 10; // 10 seconds backward
        const newTime = Math.max(this.audio.currentTime - seekAmount, 0);

        console.log(`Seeking backward to ${newTime}s`);
        this.audio.currentTime = newTime;
        this.updateProgress();
    }

    /**
     * Update play button state
     */
    updatePlayButton() {
        const playPauseBtn = Utils.getElement('#playPause');
        if (playPauseBtn) {
            // Remove any text content (emojis)
            playPauseBtn.textContent = '';

            // Create or update SVG based on state
            let svg = playPauseBtn.querySelector('svg');
            if (!svg) {
                svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
                svg.setAttribute('width', '12');
                svg.setAttribute('height', '14');
                svg.setAttribute('viewBox', '0 0 12 14');
                svg.setAttribute('fill', 'none');
                svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
                svg.style.fontSize = '11px';
                svg.style.width = '14px';
                svg.style.height = '16px';
                playPauseBtn.appendChild(svg);
            }

            // Clear existing paths
            svg.innerHTML = '';

            if (this.isPlaying) {
                // Pause icon - two vertical bars
                const path1 = document.createElementNS('http://www.w3.org/2000/svg', 'path');
                path1.setAttribute('d', 'M2 0H4V14H2V0Z');
                path1.setAttribute('fill', '#EAEDF1');
                svg.appendChild(path1);

                const path2 = document.createElementNS('http://www.w3.org/2000/svg', 'path');
                path2.setAttribute('d', 'M8 0H10V14H8V0Z');
                path2.setAttribute('fill', '#EAEDF1');
                svg.appendChild(path2);
            } else {
                // Play icon - triangle
                const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
                path.setAttribute('d', 'M10.9611 8.29313L2.99228 12.8468C1.65896 13.6087 0 12.6459 0 11.1103V6.55664V2.003C0 0.467354 1.65896 -0.49538 2.99228 0.266514L10.9611 4.82015C12.3048 5.58794 12.3048 7.52534 10.9611 8.29313Z');
                path.setAttribute('fill', '#EAEDF1');
                svg.appendChild(path);
            }

            // Force transparent background - never blue
            playPauseBtn.style.background = 'transparent';
            playPauseBtn.style.backgroundColor = 'transparent';
        }
    }

    /**
     * Update progress bar and time
     */
    updateProgress() {
        if (!this.audio) return;

        // Validate duration before calculating progress
        const duration = this.audio.duration;
        const currentTime = this.audio.currentTime;

        // Check if duration is valid (not NaN, not Infinity, and greater than 0)
        if (!isFinite(duration) || duration <= 0 || !isFinite(currentTime)) {
            // Set default values if duration is not available
            const progressFill = Utils.getElement('#progress-fill');
            const progressThumb = Utils.getElement('#progress-thumb');

            if (progressFill && progressThumb) {
                progressFill.setAttribute('width', 0);
                progressThumb.setAttribute('x', 0);
            }
            return;
        }

        const progress = (currentTime / duration) * 100;
        const progressFill = Utils.getElement('#progress-fill');
        const progressThumb = Utils.getElement('#progress-thumb');
        const currentTimeEl = Utils.getElement('#currentTime');
        const totalTime = Utils.getElement('#totalTime');

        if (progressFill && progressThumb) {
            // Update fill width (0-220px) - ensure valid number
            const fillWidth = Math.max(0, Math.min(220, (progress / 100) * 220));
            progressFill.setAttribute('width', fillWidth || 0);

            // Update thumb position (x position) - center the thumb on the fill edge
            // Ensure thumb is always visible and positioned correctly
            const thumbX = Math.max(0, Math.min(215, fillWidth - 2.5));
            progressThumb.setAttribute('x', thumbX || 0);
        }

        if (currentTimeEl) {
            currentTimeEl.textContent = Utils.formatTime(currentTime);
        }

        if (totalTime) {
            totalTime.textContent = Utils.formatTime(duration);
        }
    }

    /**
     * Handle can play event
     */
    onCanPlay() {
        console.log('Audio can play');
        this.updateProgress();

        // Don't auto-play here - loadTrack already handles autoplay
        // This prevents duplicate playback when canplay fires after loadTrack
    }

    /**
     * Handle track ended
     */
    onTrackEnded() {
        console.log('Track ended');
        this.isPlaying = false;
        this.updatePlayButton();
        // Optionally restart the track or stop
        this.audio.currentTime = 0;
    }

    /**
     * Handle audio error
     */
    onError() {
        console.error('Audio error occurred');
        this.isPlaying = false;
        this.updatePlayButton();
    }

}

// ===== PROGRESS MANAGER =====
// 📊 Gerenciador de progresso com animações - tadalas @ https://discord.gg/gCZpDV8GvS
class ProgressManager {
    constructor() {
        this.progress = 0;
        this.targetProgress = 0;
        this.animationSpeed = 2;
        this.init();
    }

    /**
     * Initialize progress manager
     */
    init() {
        this.startProgressAnimation();
    }

    /**
     * Start progress animation
     */
    startProgressAnimation() {
        const animate = () => {
            if (this.progress < this.targetProgress) {
                this.progress += this.animationSpeed;
                this.updateProgressDisplay();
                requestAnimationFrame(animate);
            }
        };
        animate();
    }

    /**
     * Update progress display
     */
    updateProgressDisplay() {
        const progressFill = Utils.getElement('#progressFill');
        const progressText = Utils.getElement('#progressText');

        if (progressFill) {
            progressFill.style.width = `${this.progress}%`;
        }

        if (progressText) {
            progressText.textContent = `${Math.round(this.progress)}%`;
        }
    }
}

// ===== THEME MANAGER =====
// 🎨 Gerenciador de temas dinâmico - Desenvolvido por tadalas @ https://discord.gg/gCZpDV8GvS
class ThemeManager {
    constructor() {
        this.defaultTheme = 'Royal';
        this.currentTheme = this.defaultTheme;
        this.loadedThemes = new Set();
        this.CDN_URL = 'https://santaloading.roleplayrp.com/img/themes';

        // Map city names to CSS file names (all lowercase)
        this.themeFileMap = {
            'CidadeNobre': 'cidadenobre',
            'Alexandria': 'alexandria',
            'Boomerang': 'boomerang',
            'Caravelas': 'caravelas',
            'Grande': 'grande',
            'Kingdom': 'kingdom',
            'District99': 'district99',
            'Krown': 'krown',
            'Orizon': 'orizon',
            'Liberty99': 'liberty99',
            'Malta': 'malta',
            'Maresia': 'maresia',
            'Real': 'real',
            'Royal': 'royal',
            'Santa': 'santa',
            'Universo': 'universo',
            'Prime': 'prime',
            'Fronteira': 'fronteira',
            'GoatRP': 'goatrp',
            'Liberty99': 'liberty99',
            'Krown': 'krown'
        };
    }

    /**
     * Get theme file name from city name
     * @param {string} cityName - City name
     * @returns {string} Theme file name (lowercase)
     */
    getThemeFileName(cityName) {
        if (!cityName) return 'royal';

        // Check if there's a mapping
        if (this.themeFileMap[cityName]) {
            return this.themeFileMap[cityName];
        }

        // Fallback: convert to lowercase
        return cityName.toLowerCase();
    }

    /**
     * Get city name from NUI or handover data
     * @returns {Promise<string>} City name
     */
    async getCityName() {
        return new Promise((resolve) => {
            // Try to get from NuiBridge first
            if (window.NuiBridge) {
                window.NuiBridge.request('getCityName')
                    .then((data) => {
                        const cityName = typeof data === 'string' ? data : data?.cityName;
                        resolve(cityName || this.defaultTheme);
                    })
                    .catch(() => {
                        // Fallback to handover data
                        const cityName = window.nuiHandoverData?.cityName;
                        resolve(cityName || this.defaultTheme);
                    });
            } else {
                // Fallback to handover data
                const cityName = window.nuiHandoverData?.cityName;
                resolve(cityName || this.defaultTheme);
            }
        });
    }

    /**
     * Load theme CSS dynamically
     * Uses onload/onerror to detect if theme exists (avoids CORS issues)
     * @param {string} theme - Theme name (city name)
     */
    async loadThemeCSS(theme) {
        if (!theme) {
            theme = this.defaultTheme;
        }

        // Remove previous theme link if exists
        const existingLink = document.querySelector(`link[data-theme]`);
        if (existingLink) {
            existingLink.remove();
        }

        return new Promise((resolve) => {
            // Get theme file name (lowercase mapping)
            const themeFileName = this.getThemeFileName(theme);
            const themeUrl = `${this.CDN_URL}/${themeFileName}.css`;

            // Create link element
            const link = document.createElement('link');
            link.rel = 'stylesheet';
            link.href = themeUrl;
            link.setAttribute('data-theme', theme);

            // Set timeout to detect if theme loads (5 seconds)
            const timeout = setTimeout(() => {
                // If timeout, assume theme doesn't exist and load default
                if (this.currentTheme !== this.defaultTheme) {
                    console.warn(`Theme ${theme} (${themeFileName}.css) load timeout, falling back to ${this.defaultTheme}`);
                    link.remove();
                    this.loadThemeCSS(this.defaultTheme).then(resolve);
                } else {
                    resolve();
                }
            }, 5000);

            // On successful load
            link.onload = () => {
                clearTimeout(timeout);
                this.currentTheme = theme;
                this.loadedThemes.add(theme);
                console.log(`Theme ${theme} (${themeFileName}.css) loaded successfully`);
                resolve();
            };

            // On error (theme doesn't exist or CORS issue)
            link.onerror = () => {
                clearTimeout(timeout);
                link.remove();

                // If this is not already the default theme, try default
                if (theme !== this.defaultTheme) {
                    console.warn(`Theme ${theme} (${themeFileName}.css) not found, falling back to ${this.defaultTheme}`);
                    this.loadThemeCSS(this.defaultTheme).then(resolve);
                } else {
                    // Even default failed, but we'll still add it (might be CORS issue)
                    console.warn(`Default theme ${this.defaultTheme} (${themeFileName}.css) failed to load, but adding anyway`);
                    this.currentTheme = this.defaultTheme;

                    // Clear handlers to prevent infinite loop if it fails again
                    link.onload = null;
                    link.onerror = null;

                    document.head.appendChild(link);
                    resolve();
                }
            };

            // Append to DOM (triggers load)
            document.head.appendChild(link);
        });
    }

    /**
     * Initialize theme manager
     */
    async init() {
        try {
            // Get city name
            const cityName = await this.getCityName();
            console.log('ThemeManager: City name received:', cityName);

            // Load theme for the city
            await this.loadThemeCSS(cityName);

            // Listen for theme changes
            this.setupThemeListener();
        } catch (error) {
            console.error('Error initializing ThemeManager:', error);
            // Load default theme on error
            await this.loadThemeCSS(this.defaultTheme);
        }
    }

    /**
     * Setup listener for theme changes
     */
    setupThemeListener() {
        // Listen for city name changes via NUI
        if (window.NuiBridge) {
            window.NuiBridge.on('city:set', (payload) => {
                const cityName = payload?.cityName || payload;
                if (cityName && cityName !== this.currentTheme) {
                    console.log('ThemeManager: City changed to:', cityName);
                    this.loadThemeCSS(cityName);
                }
            });
        }

        // Also listen for handover data changes
        const checkCityChange = () => {
            const cityName = window.nuiHandoverData?.cityName;
            if (cityName && cityName !== this.currentTheme) {
                console.log('ThemeManager: City changed to:', cityName);
                this.loadThemeCSS(cityName);
            }
        };

        // Check periodically for city changes
        setInterval(checkCityChange, 1000);
    }

    /**
     * Set theme manually
     * @param {string} theme - Theme name
     */
    async setTheme(theme) {
        await this.loadThemeCSS(theme);
    }

    /**
     * Get current theme
     * @returns {string} Current theme name
     */
    getTheme() {
        return this.currentTheme;
    }
}

// ===== MAIN APPLICATION =====
// 🎯 Aplicação principal - Desenvolvido com amor por tadalas @ https://discord.gg/gCZpDV8GvS
class LoadingScreenApp {
    constructor() {
        this.translationManager = new TranslationManager();
        this.assetLoader = new AssetLoader();
        this.themeManager = new ThemeManager();
        this.virtualKeyboard = null;
        this.musicPlayer = null;
        this.progressManager = null;
        this.vipSlider = null;
        this.isInitialized = false;
        this.isToggling = false;

        this.init();
    }

    /**
     * Initialize application
     */
    async init() {
        try {
            console.log('Initializing Santa Group Loading Screen...');

            // Wait for DOM to be ready
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', () => this.start());
            } else {
                this.start();
            }
        } catch (error) {
            console.error('Failed to initialize application:', error);
        }
    }

    /**
     * Start application
     */
    async start() {
        try {
            console.log('Starting application...');

            // Initialize theme manager (loads theme CSS dynamically)
            await this.themeManager.init();

            // Load translations
            await this.translationManager.loadTranslations();

            // Wait for city data
            await this.waitForCityData();

            // Initialize components
            this.initializeComponents();

            // Load content
            await this.loadContent();

            this.isInitialized = true;
            console.log('Application initialized successfully');

        } catch (error) {
            console.error('Error starting application:', error);
        }
    }

    /**
     * Wait for city data to be available
     * Continuously polls until city data is found
     * @returns {Promise<string>} City name
     */
    waitForCityData() {
        return new Promise((resolve) => {
            let retries = 0;
            const maxRetries = 10; // Number of retries before giving up

            const checkCityData = () => {
                if (window.nuiHandoverData?.cityName) {
                    console.log('City data found:', window.nuiHandoverData.cityName);
                    this.cityName = window.nuiHandoverData.cityName;
                    resolve(window.nuiHandoverData.cityName);
                } else if (retries < maxRetries) {
                    retries++;
                    console.log(`Waiting for city data... (Attempt ${retries}/${maxRetries})`);
                    setTimeout(checkCityData, CONFIG.RETRY_INTERVAL);
                } else {
                    console.warn(`City data not found after ${maxRetries} retries, falling back to default`);
                    this.cityName = this.themeManager.defaultTheme;
                    resolve(this.themeManager.defaultTheme);
                }
            };

            // Start checking immediately
            checkCityData();
        });
    }

    /**
     * Initialize application components
     */
    initializeComponents() {
        console.log('Initializing components...');

        // Initialize virtual keyboard
        console.log('About to initialize VirtualKeyboard...');
        this.virtualKeyboard = new VirtualKeyboard('#virtualKeyboard');
        console.log('Virtual keyboard initialized:', this.virtualKeyboard);

        // Initialize music player
        this.musicPlayer = new MusicPlayer();
        console.log('Music player initialized');

        // Initialize progress manager
        this.progressManager = new ProgressManager();
        console.log('Progress manager initialized');

        // Initialize VIP slider
        this.vipSlider = new VIPSlider();
        console.log('VIP slider initialized');

        // Setup custom cursor
        this.setupCustomCursor();
        console.log('Custom cursor setup completed');

        // Bind global events
        this.bindGlobalEvents();
        console.log('Global events bound');
    }

    /**
     * Load application content
     */
    async loadContent() {
        const cityName = window.nuiHandoverData?.cityName;

        if (!cityName) {
            console.warn('No cityName provided. Content loading skipped.');
            return;
        }

        console.log('Loading content for city:', cityName);

        try {
            // Validate city configuration
            this.validateCityConfiguration(cityName);

            // Update city logo
            this.updateCityLogo(cityName);

            // Update city name in DOM
            this.updateCityName(cityName);

            // Apply static texts (ensure it happens after DOM is ready)
            if (window.cityConfigManager) {
                const config = window.cityConfigManager.getCityConfig(cityName);
                if (config && config.staticTexts) {
                    console.log('Calling applyStaticTexts from loadContent for:', cityName);
                    window.cityConfigManager.applyStaticTexts(cityName, config.staticTexts);

                    // Also try after a delay to ensure all elements are ready
                    setTimeout(() => {
                        console.log('Re-applying static texts after delay');
                        window.cityConfigManager.applyStaticTexts(cityName, config.staticTexts, true);
                    }, 800);
                } else {
                    console.warn('No staticTexts found in config for:', cityName);
                }

                // Apply city config including slides
                console.log('Applying city config for:', cityName);
                window.cityConfigManager.applyCityConfig(cityName);

                // Retry applying slides after a delay in case vipSlider wasn't ready
                setTimeout(() => {
                    if (window.cityConfigManager && window.loadingScreenApp?.vipSlider) {
                        const config = window.cityConfigManager.getCityConfig(cityName);
                        if (config && Array.isArray(config.slides) && config.slides.length > 0) {
                            console.log('Retrying to apply slides after delay');
                            window.cityConfigManager.applySlidesOnly(cityName);
                        }
                    }
                }, 1000);
            } else {
                console.error('cityConfigManager not available');
            }

            // Load images
            const imageUrl = `https://santaloading.roleplayrp.com/img/newloading/${cityName}/banner_cd.png`;
            await this.assetLoader.preloadImage(imageUrl);

            // Update content preview
            const contentPreview = Utils.getElement('#contentPreview');
            if (contentPreview) {
                contentPreview.src = imageUrl;
            }

            // Update translations
            this.translationManager.updateTranslatedElements();

            // Show loaded content
            this.showLoadedContent();

            // Keyboard demo removed - no random key highlighting

        } catch (error) {
            console.error('Error loading content:', error);
            this.showLoadedContent(); // Show content even if some assets fail
        }
    }

    /**
     * Hide welcome skeleton loader and show actual content
     */
    hideWelcomeSkeleton() {
        const skeleton = Utils.getElement('#welcomeSkeleton');
        const content = Utils.getElement('#welcomeContent');

        if (skeleton) {
            skeleton.classList.add('skeleton-hidden');
        }
        if (content) {
            content.classList.remove('skeleton-hidden');
        }
    }

    /**
     * Update city name in DOM
     * @param {string} cityName - City name
     */
    updateCityName(cityName) {
        if (!cityName) return;

        const cityNameEl = document.querySelector('#welcomeContent .city-name');
        console.log('Updating city name via loadContent:', cityName, 'Element found:', !!cityNameEl);
        if (cityNameEl) {
            cityNameEl.textContent = cityName;
            console.log('City name updated successfully to:', cityName);
            // Hide skeleton and show content when city name is loaded
            this.hideWelcomeSkeleton();
        } else {
            console.warn('City name element (.city-name) not found, will retry');
            // Retry after a short delay
            setTimeout(() => {
                const retryCityNameEl = document.querySelector('#welcomeContent .city-name');
                if (retryCityNameEl) {
                    retryCityNameEl.textContent = cityName;
                    console.log('City name updated on retry to:', cityName);
                    this.hideWelcomeSkeleton();
                } else {
                    console.error('City name element still not found after retry');
                }
            }, 200);
        }
    }

    /**
     * Update city logo based on city name
     * @param {string} cityName - City name
     */
    updateCityLogo(cityName) {
        const logoImage = Utils.getElement('.logo-image');
        if (!logoImage) {
            console.warn('Logo image element not found');
            return;
        }

        // Map city names to their corresponding image names
        const cityLogoMap = {
            'santa': 'santanew.png',
            'alexandria': 'alexandria.png',
            'boomerang': 'boomerang.webp',
            'caravelas': 'caravelas.png',
            'divina': 'divina.png',
            'galaxy': 'galaxy.png',
            'grande': 'grande2.png',
            'kings': 'knglogo.png',
            'kingdom': 'knglogo.png',
            'district99': 'District99.png',
            'krown': 'District99.png',
            'orizon': 'Orizon.png',
            'liberty99': 'Liberty99.png',
            'malta': 'new_malta.png',
            'maresia': 'newmaresia.png',
            'nobre': 'nobre_2.png',
            'cidadenobre': 'nobre_2.png', // Alternative name for CidadeNobre
            'real': 'real.png',
            'royal': 'new_royal.png',
            'universo': 'universo2.png',
            'prime': 'prime.png',
            'fronteira': 'fronteira.png',
            'liberty99': 'liberty99.png',
            'goatrp': 'goatrp.png',
            'krown': 'krown.png'
        };

        // Get the logo filename for the city, default to santa.png if not found
        const normalizedCityName = cityName?.toLowerCase() || '';
        const logoFilename = cityLogoMap[normalizedCityName] || cityLogoMap['santa'];
        const logoUrl = `https://santaloading.roleplayrp.com/img/imagens_hud/${logoFilename}`;

        console.log(`Updating city logo for ${cityName}: ${logoUrl}`);

        // Update the logo source
        logoImage.src = logoUrl;
        logoImage.alt = `${cityName} Logo`;

        // Handle logo load error
        logoImage.onerror = () => {
            console.warn(`Failed to load logo for city: ${cityName}, falling back to default`);
            logoImage.src = 'https://santaloading.roleplayrp.com/img/newloading/logo.png';
            logoImage.alt = 'Santa Logo';
        };

        // Handle successful logo load
        logoImage.onload = () => {
            console.log(`Successfully loaded logo for city: ${cityName}`);
        };
    }

    /**
     * Validate city configuration for local assets only
     * @param {string} cityName - City name to validate
     */
    validateCityConfiguration(cityName) {
        if (!window.cityConfigManager) {
            console.warn('City config manager not available');
            return;
        }

        const cityConfig = window.cityConfigManager.getCityConfig(cityName);

        if (!cityConfig) {
            console.error(`No configuration found for city: ${cityName}`);
            return;
        }

        // Validate video URL format
        if (cityConfig.video) {
            const lower = cityConfig.video.toLowerCase();
            const isValidHost = cityConfig.video.includes('santaloading.roleplayrp.com') || cityConfig.video.includes('cdn.santagroup.gg');
            const hasValidExt = lower.endsWith('.mp4') || lower.endsWith('.webm');
            if (!isValidHost || !hasValidExt) {
                console.warn(`Video URL for city ${cityName} may not be valid:`, cityConfig.video);
                console.warn('Expected: .mp4/.webm file from santaloading.roleplayrp.com or cdn.santagroup.gg');
            } else {
                console.log(`Valid local video configuration for city: ${cityName}`);
            }
        } else {
            console.warn(`No video configured for city: ${cityName}`);
        }
    }

    /**
     * Show loaded content with animations
     */
    showLoadedContent() {
        // Don't show content-card here - it will be shown when first slide loads
        const elements = [
            Utils.getElement('.keyboard-container'),
            Utils.getElement('.footer')
        ];

        elements.forEach((element, index) => {
            if (element) {
                setTimeout(() => {
                    element.classList.add('loaded', 'fade-in');
                }, index * 200);
            }
        });
    }

    /**
     * Setup custom cursor
     */
    setupCustomCursor() {
        // Custom cursor disabled - using default browser cursor
        console.log('Custom cursor disabled - using default browser cursor');
    }

    /**
     * Bind global events
     */
    bindGlobalEvents() {
        console.log('Binding global events...');

        // Handle view more button
        const viewMoreBtn = Utils.getElement('#viewMoreBtn');
        if (viewMoreBtn) {
            viewMoreBtn.addEventListener('click', () => {
                console.log('View more button clicked');
                // TODO: Implement view more functionality
            });
        }

        // Handle shortcuts button - opens keyboard directly
        const shortcutsBtn = Utils.getElement('#shortcutsBtn');
        if (shortcutsBtn) {
            shortcutsBtn.addEventListener('click', (e) => {
                console.log('Shortcuts button clicked - opening keyboard directly');
                e.preventDefault();
                e.stopPropagation();
                this.toggleKeyboard();
                this.toggleShortcutsButtonState();
            });
        }


        // Close keyboard overlay when clicking outside
        document.addEventListener('click', (e) => {
            const mainContent = Utils.getElement('#mainContent');
            const keyboardContainer = Utils.getElement('.keyboard-container');
            const shortcutsBtn = Utils.getElement('#shortcutsBtn');

            // Check if keyboard is currently visible (using class instead of style)
            if (mainContent && mainContent.classList.contains('show')) {
                // Check if click is outside keyboard container and not on shortcuts button
                const isClickOnKeyboard = keyboardContainer && keyboardContainer.contains(e.target);
                const isClickOnShortcutsBtn = shortcutsBtn && shortcutsBtn.contains(e.target);

                if (!isClickOnKeyboard && !isClickOnShortcutsBtn) {
                    console.log('Clicking outside keyboard, closing overlay');
                    this.toggleKeyboard();
                    this.toggleShortcutsButtonState();
                }
            }
        });
    }


    /**
     * Toggle keyboard visibility
     */
    toggleKeyboard() {
        // Prevent multiple rapid calls
        if (this.isToggling) {
            console.log('Keyboard toggle already in progress, ignoring');
            return;
        }

        this.isToggling = true;
        console.log('toggleKeyboard called');

        const mainContent = Utils.getElement('#mainContent');

        console.log('Main content found:', mainContent);

        if (!mainContent) {
            console.error('Main content not found!');
            this.isToggling = false;
            return;
        }

        // Check if keyboard is currently visible
        const isVisible = mainContent.classList.contains('show');
        console.log('Keyboard is currently visible:', isVisible);

        if (isVisible) {
            // Hide keyboard and show hidden elements
            console.log('Hiding keyboard');
            mainContent.classList.remove('show');
            document.body.classList.remove('keyboard-active');
            setTimeout(() => {
                this.showHiddenElements();
                this.isToggling = false;
            }, 300); // Wait for transition to complete
        } else {
            // Show keyboard and hide elements
            console.log('Showing keyboard');
            this.hideElementsForKeyboard();
            mainContent.classList.add('show');
            document.body.classList.add('keyboard-active');

            // Ensure keyboard is properly initialized
            this.ensureKeyboardInitialized();

            // Reset toggle flag after a short delay
            setTimeout(() => {
                this.isToggling = false;
            }, 100);
        }
    }

    /**
     * Toggle shortcuts button active state
     */
    toggleShortcutsButtonState() {
        const shortcutsBtn = Utils.getElement('#shortcutsBtn');
        if (!shortcutsBtn) {
            console.warn('Shortcuts button not found');
            return;
        }

        const mainContent = Utils.getElement('#mainContent');
        const isKeyboardVisible = mainContent && mainContent.classList.contains('show');

        if (isKeyboardVisible) {
            shortcutsBtn.classList.add('active');
            console.log('Shortcuts button set to active state');
        } else {
            shortcutsBtn.classList.remove('active');
            console.log('Shortcuts button set to normal state');
        }
    }

    /**
     * Hide elements when keyboard is active
     */
    hideElementsForKeyboard() {
        console.log('Hiding elements for keyboard');

        // Hide content card (parent of slider)
        const contentCard = Utils.getElement('.content-card');
        if (contentCard) {
            contentCard.style.display = 'none';
            console.log('Content card hidden');
        }

        // Hide slider container
        const sliderContainer = Utils.getElement('.slider-container');
        if (sliderContainer) {
            sliderContainer.style.display = 'none';
            console.log('Slider container hidden');
        }

        // Hide logo container
        const logoContainer = Utils.getElement('.logo-container');
        if (logoContainer) {
            logoContainer.style.display = 'none';
            console.log('Logo container hidden');
        }

        // Hide welcome text container
        const welcomeTextContainer = Utils.getElement('.welcome-text-container');
        if (welcomeTextContainer) {
            welcomeTextContainer.style.display = 'none';
            console.log('Welcome text container hidden');
        }
    }

    /**
     * Show hidden elements when keyboard is closed
     */
    showHiddenElements() {
        console.log('Showing hidden elements');

        // Show content card (parent of slider)
        const contentCard = Utils.getElement('.content-card');
        if (contentCard) {
            contentCard.style.display = 'flex';
            console.log('Content card shown');
        }

        // Show slider container
        const sliderContainer = Utils.getElement('.slider-container');
        if (sliderContainer) {
            sliderContainer.style.display = 'flex';
            console.log('Slider container shown');
        }

        // Show logo container
        const logoContainer = Utils.getElement('.logo-container');
        if (logoContainer) {
            logoContainer.style.display = 'flex';
            console.log('Logo container shown');
        }

        // Show welcome text container
        const welcomeTextContainer = Utils.getElement('.welcome-text-container');
        if (welcomeTextContainer) {
            welcomeTextContainer.style.display = 'flex';
            console.log('Welcome text container shown');
        }
    }

    /**
     * Ensure keyboard is properly initialized
     */
    ensureKeyboardInitialized() {
        console.log('Ensuring keyboard is initialized...');

        const virtualKeyboardContainer = Utils.getElement('#virtualKeyboard');
        console.log('Virtual keyboard container found:', virtualKeyboardContainer);

        if (!virtualKeyboardContainer) {
            console.error('Virtual keyboard container not found!');
            return;
        }

        // Check if keyboard is empty
        if (virtualKeyboardContainer.children.length === 0) {
            console.log('Keyboard container is empty, re-initializing...');

            if (this.virtualKeyboard) {
                console.log('Re-initializing existing VirtualKeyboard instance...');
                this.virtualKeyboard.init();
            } else {
                console.log('Creating new VirtualKeyboard instance...');
                this.virtualKeyboard = new VirtualKeyboard('#virtualKeyboard');
            }
        } else {
            console.log('Keyboard container has content, no re-initialization needed');
        }

        // Only reinitialize tooltip manager if it doesn't exist or is not properly initialized
        if (!window.keyboardTooltipManager || !window.keyboardTooltipManager.isInitialized) {
            console.log('Initializing keyboard tooltip manager...');
            if (window.keyboardTooltipManager) {
                window.keyboardTooltipManager.reinitialize();
            } else {
                window.keyboardTooltipManager = new KeyboardTooltipManager();
            }
        } else {
            console.log('Tooltip manager already initialized, skipping re-initialization');
        }
    }
}

// ===== LANGUAGE DETECTION FOR KEYBOARD TOOLTIPS =====
// Detect which language a keyboard shortcut description is written in,
// so the hardcoded title fallback matches the surrounding UI language.
function detectLanguage(text) {
    if (!text) return 'pt';
    if (/[؀-ۿ]/.test(text)) return 'ar';
    const lower = text.toLowerCase();
    if (/\butilisez\b|\bmaintenez\b|votre|téléphone|inventaire/.test(lower)) return 'fr';
    if (/\busa para\b|\bmantén\b|\btu arma\b|micrófono|inventario|menú/.test(lower)) return 'es';
    if (/\buse to\b|\bhold to\b|your|the\s/.test(lower)) return 'en';
    return 'pt';
}

// ===== KEYBOARD TOOLTIP MANAGER =====
class KeyboardTooltipManager {
    constructor() {
        this.tooltip = null;
        this.tooltipIcon = null;
        this.tooltipKey = null;
        this.tooltipTitle = null;
        this.tooltipDescription = null;
        this.shortcuts = this.getKeyboardShortcuts();
        this.isInitialized = false;
        this.eventsBound = false;
        this.defaultIcon = `<svg width="15" height="21" viewBox="0 0 15 21" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path opacity="0.4" d="M4.89631 5.75V11.75L3.48209 10.3358C3.10702 9.96071 2.59831 9.75 2.06788 9.75H2.00231C0.547737 9.75 -0.420327 11.2534 0.181581 12.5776L2.83049 18.4052C3.47957 19.8332 4.90338 20.75 6.47196 20.75H10.575C12.0104 20.75 13.3358 19.9809 14.048 18.7346L14.3693 18.1723C14.7146 17.5679 14.8963 16.8839 14.8963 16.1877V15.75C14.8963 13.5409 13.1054 11.75 10.8963 11.75H8.89631V5.75C8.89631 4.64543 8.00088 3.75 6.89631 3.75C5.79174 3.75 4.89631 4.64543 4.89631 5.75Z" fill="var(--main-500)"/>
            <path fill-rule="evenodd" clip-rule="evenodd" d="M6.8963 1.5C3.99681 1.5 1.6463 3.85051 1.6463 6.75C1.6463 7.16421 1.31051 7.5 0.896301 7.5C0.482088 7.5 0.146301 7.16421 0.146301 6.75C0.146301 3.02208 3.16838 0 6.8963 0C10.6242 0 13.6463 3.02208 13.6463 6.75C13.6463 7.16421 13.3105 7.5 12.8963 7.5C12.4821 7.5 12.1463 7.16421 12.1463 6.75C12.1463 3.85051 9.7958 1.5 6.8963 1.5Z" fill="var(--main-500)"/>
        </svg>`;
        this.defaultText = 'Passe o mouse sobre as teclas destacadas para saber mais';
        this.init();
    }

    /**
     * Get keyboard shortcuts mapping
     * 
     * ===== TECLAS DISPONÍVEIS NO INDEX.HTML =====
     * 
     * Todas as teclas abaixo podem ser usadas no keyboardConfig enviado via handover.
     * As teclas destacadas em azul (var(--main-500)) são as que têm tooltips configurados por padrão.
     * 
     * === TECLAS FUNÇÃO (F1-F12) ===
     * - 'esc'          : ESC (destacada)
     * - 'f1'           : F1
     * - 'f2'           : F2
     * - 'f3'           : F3
     * - 'f4'           : F4
     * - 'f5'           : F5 (destacada)
     * - 'f6'           : F6
     * - 'f7'           : F7
     * - 'f8'           : F8
     * - 'f9'           : F9
     * - 'f10'          : F10
     * - 'f11'          : F11
     * - 'f12'          : F12
     * 
     * === TECLAS NUMÉRICAS E SÍMBOLOS ===
     * - 'quote'        : ` (backtick/acento grave) - destacada na linha superior
     * - '1'            : 1
     * - '2'            : 2
     * - '3'            : 3
     * - '4'            : 4
     * - '5'            : 5
     * - '6'            : 6
     * - '7'            : 7
     * - '8'            : 8
     * - '9'            : 9
     * - '0'            : 0
     * - 'minus'        : - (hífen)
     * - 'equals'       : = (igual)
     * - 'backspace'    : Backspace
     * 
     * === TECLAS ALFABÉTICAS (PRIMEIRA LINHA) ===
     * - 'tab'          : Tab (destacada)
     * - 'q'            : Q
     * - 'w'            : W
     * - 'e'            : E
     * - 'r'            : R (destacada)
     * - 't'            : T (destacada)
     * - 'y'            : Y
     * - 'u'            : U
     * - 'i'            : I
     * - 'o'            : O
     * - 'p'            : P (destacada)
     * - 'bracket-left' : [ (colchete esquerdo)
     * - 'bracket-right': ] (colchete direito)
     * - 'enter'        : Enter (linha superior)
     * 
     * === TECLAS ALFABÉTICAS (SEGUNDA LINHA) ===
     * - 'caps-lock'    : Caps Lock (destacada)
     * - 'a'            : A
     * - 's'            : S
     * - 'd'            : D
     * - 'f'            : F
     * - 'g'            : G
     * - 'h'            : H
     * - 'j'            : J
     * - 'k'            : K (destacada)
     * - 'l'            : L
     * - 'semicolon'    : ; (ponto e vírgula)
     * - 'quote'        : ' (aspas simples) - linha alfabética
     * - 'enter'        : Enter (linha inferior)
     * 
     * === TECLAS ALFABÉTICAS (TERCEIRA LINHA) ===
     * - 'shift-left'   : Shift Esquerdo
     * - 'z'            : Z
     * - 'x'            : X
     * - 'c'            : C
     * - 'v'            : V
     * - 'b'            : B
     * - 'n'            : N
     * - 'm'            : M
     * - 'comma'        : , (vírgula)
     * - 'period'      : . (ponto)
     * - 'slash'       : / (barra)
     * - 'shift-right' : Shift Direito
     * 
     * === TECLAS DE CONTROLE (LINHA INFERIOR) ===
     * - 'ctrl-left'    : Ctrl Esquerdo
     * - 'win-left'     : Windows Esquerdo
     * - 'alt-left'     : Alt Esquerdo
     * - 'space'        : Barra de Espaço
     * - 'alt-right'    : Alt Direito
     * - 'win-right'    : Windows Direito
     * - 'menu'         : Menu (tecla de contexto)
     * - 'ctrl-right'   : Ctrl Direito
     * 
     * === TECLAS DE NAVEGAÇÃO E CONTROLE (LADO DIREITO) ===
     * - 'print'        : Print Screen
     * - 'scroll-lock'  : Scroll Lock
     * - 'pause'        : Pause/Break
     * - 'ins'          : Insert
     * - 'home'         : Home (destacada)
     * - 'pgup'         : Page Up
     * - 'del'          : Delete
     * - 'end'          : End
     * - 'pgdn'         : Page Down
     * - 'arrow-up'     : Seta para Cima
     * - 'arrow-left'   : Seta para Esquerda
     * - 'arrow-down'   : Seta para Baixo
     * - 'arrow-right'  : Seta para Direita
     * 
     * ===== EXEMPLO DE USO NO SERVIDOR (Lua) =====
     * 
     * deferrals.handover({
     *     keyboardConfig = {
     *         ['esc'] = 'Use para abrir o Menu principal',
     *         ['f5'] = 'Use para abrir um chamado de ajuda',
     *         ['f8'] = 'Usar comandos',
     *         ['tab'] = 'Use para acessar a Hotbar de itens',
     *         ['caps-lock'] = 'Segure para falar na rádio conectada.',
     *         ['r'] = 'Use para recarregar a sua arma equipada.',
     *         ['t'] = 'Use para abrir o chat',
     *         ['p'] = 'Use para abrir o mapa',
     *         ['k'] = 'Use para usar o celular',
     *         ['home'] = 'Use para aumentar/dimunuir o volume do microfone',
     *         ['quote'] = 'Use para abrir o seu inventário'
     *         -- Adicione qualquer outra tecla da lista acima
     *     }
     * })
     * 
     * ===== TECLAS DESTACADAS POR PADRÃO =====
     * As seguintes teclas vêm com tooltips pré-configurados:
     * - esc, f5, quote (backtick), tab, r, t, p, caps-lock, k, home
     * 
     * @returns {Object} Keyboard shortcuts data
     */
    getKeyboardShortcuts() {
        // Try to get keyboard config from handover data first
        if (window.nuiHandoverData?.keyboardConfig) {
            return window.nuiHandoverData.keyboardConfig;
        }

        // Try to get keyboard config from city configuration
        if (window.cityConfigManager && window.nuiHandoverData?.cityName) {
            const cityName = window.nuiHandoverData.cityName;
            const keyboardConfig = window.cityConfigManager.getKeyboardConfig(cityName);
            if (keyboardConfig && Object.keys(keyboardConfig).length > 0) {
                return keyboardConfig;
            }
        }

        // Default keyboard shortcuts (fallback)
        return {
            'esc': 'Use para abrir o Menu principal',
            'f5': 'Use para abrir um chamado de ajuda',
            'f8': 'Usar comandos',
            'tab': 'Use para acessar a Hotbar de itens',
            'caps-lock': 'Segure para falar na rádio conectada.',
            'r': 'Use para recarregar a sua arma equipada.',
            't': 'Use para abrir o chat',
            'p': 'Use para abrir o mapa',
            'k': 'Use para usar o celular',
            'home': 'Use para aumentar/dimunuir o volume do microfone',
            'quote': 'Use para abrir o seu inventário'
        };
    }

    /**
     * Update keyboard shortcuts from handover data
     * @param {Object} keyboardConfig - Keyboard configuration object
     */
    updateKeyboardShortcuts(keyboardConfig) {
        if (!keyboardConfig || typeof keyboardConfig !== 'object') {
            console.warn('Invalid keyboard config provided');
            return;
        }

        // Update shortcuts
        this.shortcuts = keyboardConfig;

        // Update handover data
        if (window.nuiHandoverData) {
            window.nuiHandoverData.keyboardConfig = keyboardConfig;
        }

        console.log('Keyboard shortcuts updated from handover data:', keyboardConfig);
    }

    /**
     * Initialize tooltip manager
     */
    init() {
        // Use the existing keybind-info element instead of creating a new tooltip
        this.tooltip = Utils.getElement('#keybindInfo');
        this.tooltipIcon = Utils.getElement('#keybindIcon');
        this.tooltipKey = Utils.getElement('#keybindKey');
        this.tooltipTitle = Utils.getElement('#keybindTitle');
        this.tooltipDescription = Utils.getElement('#keybindDescription');

        if (!this.tooltip || !this.tooltipIcon || !this.tooltipKey || !this.tooltipDescription) {
            console.warn('KeyboardTooltipManager: Tooltip elements not found');
            this.isInitialized = false;
            return;
        }

        // Set default content and keep tooltip visible
        this.setDefaultContent();

        this.bindKeyboardEvents();
        this.isInitialized = true;
        console.log('KeyboardTooltipManager initialized');
    }

    /**
     * Bind events to keyboard keys
     */
    bindKeyboardEvents() {
        const keyboardContainer = Utils.getElement('.keyboard-container');
        if (!keyboardContainer) {
            console.warn('Keyboard container not found');
            return;
        }

        // Check if events are already bound to avoid duplicates
        if (this.eventsBound) {
            console.log('KeyboardTooltipManager: Events already bound, skipping');
            return;
        }

        // Get all keyboard keys
        const svgKeys = keyboardContainer.querySelectorAll('svg rect[id^="key-"]');

        svgKeys.forEach(key => {
            // Check if event listeners are already attached
            if (!key.hasAttribute('data-tooltip-bound')) {
                key.addEventListener('mouseenter', (e) => this.handleKeyHover(e, key, true));
                key.addEventListener('mouseleave', (e) => this.handleKeyHover(e, key, false));
                key.addEventListener('click', (e) => this.handleKeyClick(e, key));
                key.setAttribute('data-tooltip-bound', 'true');
            }

            // Add cursor pointer for better UX
            key.style.cursor = 'pointer';
        });

        this.eventsBound = true;
        console.log(`KeyboardTooltipManager: Bound events to ${svgKeys.length} keys`);
    }

    /**
     * Handle key hover event
     * @param {Event} event - Hover event
     * @param {Element} keyElement - Key element
     * @param {boolean} isEntering - Whether mouse is entering or leaving
     */
    handleKeyHover(event, keyElement, isEntering) {
        if (isEntering) {
            this.showTooltip(keyElement);
        } else {
            this.hideTooltip();
        }
    }

    /**
     * Handle key click event (send data to backend if key is in shortcuts)
     * @param {Event} event - Click event
     * @param {Element} keyElement - Key element
     */
    handleKeyClick(event, keyElement) {
        const keyId = keyElement.id;
        const keyName = keyId.replace('key-', '');

        // Check if this key is in the shortcuts list (should send data)
        if (this.shortcuts[keyName]) {
            console.log(`KeyboardTooltipManager: Sending key data to backend: ${keyName}`);

            // Send key data to backend via NuiBridge
            if (window.NuiBridge) {
                window.NuiBridge.emitToBackend('keyboard:keyPressed', {
                    key: keyName,
                    title: this.getKeyTitle(keyName),
                    description: this.shortcuts[keyName]
                });
            } else {
                console.warn('NuiBridge not available, cannot send key data');
            }
        }
    }

    /**
     * Set default tooltip content
     */
    setDefaultContent() {
        this.tooltipIcon.innerHTML = this.defaultIcon;
        this.tooltipIcon.style.display = 'flex';
        this.tooltipKey.textContent = '';
        this.tooltipKey.style.display = 'none';
        this.tooltipTitle.textContent = '';
        this.tooltipTitle.style.display = 'none';

        // Use current defaultText (may have been updated by staticTexts)
        const textToUse = this.defaultText || 'Passe o mouse sobre as teclas destacadas para saber mais';
        this.tooltipDescription.textContent = textToUse;

        // Set description color to blue for default state
        this.tooltipDescription.style.color = 'var(--main-500)';
        // Reset tooltip position to default
        if (this.tooltip) {
            this.tooltip.style.bottom = '-60px';
        }
    }

    /**
     * Show tooltip for a key
     * @param {Element} keyElement - Key element
     */
    showTooltip(keyElement) {
        const keyId = keyElement.id;
        const keyName = keyId.replace('key-', '');

        // Check if this key has a shortcut defined
        if (this.shortcuts[keyName]) {
            const shortcut = this.shortcuts[keyName];

            // Hide icon and show key-specific content
            this.tooltipIcon.style.display = 'none';
            this.tooltipKey.textContent = keyName.toUpperCase();
            this.tooltipKey.style.display = 'flex';
            this.tooltipTitle.textContent = this.getKeyTitle(keyName);
            this.tooltipTitle.style.display = 'block';
            this.tooltipDescription.textContent = shortcut;
            // Change description color to white for active state
            this.tooltipDescription.style.color = '#ffffff';

            // Adjust tooltip vertical position for specific keys that overlap the keyboard
            if (this.tooltip) {
                if (keyName === 'home') {
                    // Move a bit further down to avoid covering the keyboard
                    this.tooltip.style.bottom = '-80px';
                } else {
                    // Default position for other keys
                    this.tooltip.style.bottom = '-60px';
                }
            }
        } else {
            // Show default content for keys without shortcuts
            this.setDefaultContent();
        }
    }

    /**
     * Extract title from keyboard description
     * @param {string} description - Keyboard description
     * @param {string} keyName - Key name for fallback
     * @returns {string} Extracted title
     */
    extractTitleFromDescription(description, keyName) {
        if (!description) return '';

        // Mapping of common patterns to extract titles
        // Order matters: more specific patterns first to avoid false matches
        // (e.g., "microphone" should be checked before "phone")
        const titlePatterns = [
            // Longest/most specific patterns first
            ['volume do microfone', 'Volume do Microfone'],
            ['microphone volume', 'Microphone Volume'],
            ['volumen del micrófono', 'Volumen del Micrófono'],
            ['volume du microphone', 'Volume du Microphone'],
            ['صوت الميكروفون', 'صوت الميكروفون'],
            ['menu principal', 'Menu Principal'],
            ['menú principal', 'Menú Principal'],
            ['main menu', 'Main Menu'],
            ['القائمة الرئيسية', 'القائمة الرئيسية'],
            ['chamado de ajuda', 'Chamado de Ajuda'],
            ['help ticket', 'Help Ticket'],
            ['ticket de ayuda', 'Ticket de Ayuda'],
            ['ticket d\'aide', 'Ticket d\'Aide'],
            ['طلب المساعدة', 'طلب المساعدة'],
            ['hotbar de itens', 'Hotbar de Itens'],
            ['items hotbar', 'Items Hotbar'],
            ['barra de items', 'Barra de Items'],
            ['hotbar des objets', 'Hotbar des Objets'],
            ['شريط العناصر', 'شريط العناصر'],
            ['recarregar arma', 'Recarregar Arma'],
            ['reload weapon', 'Reload Weapon'],
            ['إعادة تعبئة السلاح', 'إعادة تعبئة السلاح'],
            ['increase/decrease', 'Microphone Volume'],
            // Medium patterns
            ['inventário', 'Inventário'],
            ['inventory', 'Inventory'],
            ['inventario', 'Inventario'],
            ['inventaire', 'Inventaire'],
            ['حقيبتك', 'الحقيبة'],
            ['comandos', 'Comandos'],
            ['commands', 'Commands'],
            ['rádio', 'Rádio'],
            ['radio', 'Radio'],
            ['الراديو', 'الراديو'],
            ['recarregar', 'Recarregar Arma'],
            ['recargar', 'Recargar Arma'],
            ['recharger', 'Recharger Arme'],
            ['reload your', 'Reload Weapon'],
            ['reload', 'Reload Weapon'],
            ['mapa', 'Mapa'],
            ['map', 'Map'],
            ['carte', 'Carte'],
            ['الخريطة', 'الخريطة'],
            ['celular', 'Celular'],
            ['téléphone', 'Téléphone'],
            ['الهاتف', 'الهاتف'],
            // Short patterns last (to avoid false matches)
            ['chat', 'Chat'],
            ['الدردشة', 'الدردشة'],
            ['phone', 'Phone']
        ];

        // Try to find a match (case insensitive)
        const lowerDesc = description.toLowerCase();
        for (const [pattern, title] of titlePatterns) {
            if (lowerDesc.includes(pattern)) {
                return title;
            }
        }

        // Fallback: try to extract from common sentence patterns
        // "Use to open your X" -> "X"
        // "Use para abrir o seu X" -> "X"
        // "Use to use the X" -> "X"
        // "Hold to speak on the X" -> "X"
        const regexPatterns = [
            /(?:use\s+(?:to|para)\s+(?:open|abrir)\s+(?:your|the|o)\s+(?:seu\s+)?)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+use\s+(?:the|o)\s+)(.+?)(?:\s|$|\.)/i,
            /(?:hold\s+(?:to|para)\s+speak\s+(?:on|na)\s+(?:the|a)\s+)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+(?:access|acessar)\s+(?:the|a)\s+)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+increase\/decrease\s+)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+reload\s+(?:your|the|o)\s+(?:seu\s+)?(?:equipped\s+)?)(.+?)(?:\s|$|\.)/i
        ];

        for (const pattern of regexPatterns) {
            const match = description.match(pattern);
            if (match && match[1]) {
                let extracted = match[1].trim();
                // Remove trailing punctuation
                extracted = extracted.replace(/[.,;:!?]$/, '');

                // Special handling for reload/weapon
                if (lowerDesc.includes('reload') && extracted.toLowerCase().includes('weapon')) {
                    return 'Reload Weapon';
                }

                // Capitalize first letter
                if (extracted) {
                    return extracted.charAt(0).toUpperCase() + extracted.slice(1);
                }
            }
        }

        // Final fallback: use hardcoded titles — pick language from description content
        const lang = detectLanguage(description);
        const titlesByLang = {
            ar: {
                'esc': 'القائمة الرئيسية',
                'f5': 'طلب المساعدة',
                'f8': 'الأوامر',
                'tab': 'شريط العناصر',
                'caps-lock': 'الراديو',
                'r': 'إعادة تعبئة السلاح',
                't': 'الدردشة',
                'p': 'الخريطة',
                'k': 'الهاتف',
                'home': 'صوت الميكروفون',
                'quote': 'الحقيبة'
            },
            es: {
                'esc': 'Menú Principal',
                'f5': 'Ticket de Ayuda',
                'f8': 'Comandos',
                'tab': 'Barra de Items',
                'caps-lock': 'Radio',
                'r': 'Recargar Arma',
                't': 'Chat',
                'p': 'Mapa',
                'k': 'Celular',
                'home': 'Volumen del Micrófono',
                'quote': 'Inventario'
            },
            fr: {
                'esc': 'Menu Principal',
                'f5': 'Ticket d\'Aide',
                'f8': 'Commandes',
                'tab': 'Hotbar des Objets',
                'caps-lock': 'Radio',
                'r': 'Recharger Arme',
                't': 'Chat',
                'p': 'Carte',
                'k': 'Téléphone',
                'home': 'Volume du Microphone',
                'quote': 'Inventaire'
            },
            en: {
                'esc': 'Main Menu',
                'f5': 'Help Ticket',
                'f8': 'Commands',
                'tab': 'Items Hotbar',
                'caps-lock': 'Radio',
                'r': 'Reload Weapon',
                't': 'Chat',
                'p': 'Map',
                'k': 'Phone',
                'home': 'Microphone Volume',
                'quote': 'Inventory'
            },
            pt: {
                'esc': 'Menu Principal',
                'f5': 'Chamado de Ajuda',
                'f8': 'Comandos',
                'tab': 'Hotbar de Itens',
                'caps-lock': 'Rádio',
                'r': 'Recarregar Arma',
                't': 'Chat',
                'p': 'Mapa',
                'k': 'Celular',
                'home': 'Volume do Microfone',
                'quote': 'Inventário'
            }
        };
        const fallbackTitles = titlesByLang[lang] || titlesByLang.pt;
        return fallbackTitles[keyName] || '';
    }

    /**
     * Get title for a key
     * @param {string} keyName - Key name
     * @returns {string} Key title
     */
    getKeyTitle(keyName) {
        // Try to get title from keyboard description first
        if (this.shortcuts && this.shortcuts[keyName]) {
            const extracted = this.extractTitleFromDescription(this.shortcuts[keyName], keyName);
            if (extracted) {
                return extracted;
            }
        }

        // Fallback to hardcoded titles
        const titles = {
            'esc': 'Menu Principal',
            'f5': 'Chamado de Ajuda',
            'f8': 'Comandos',
            'tab': 'Hotbar de Itens',
            'caps-lock': 'Rádio',
            'r': 'Recarregar Arma',
            't': 'Chat',
            'p': 'Mapa',
            'k': 'Celular',
            'home': 'Volume do Microfone',
            'quote': 'Inventário'
        };
        return titles[keyName] || '';
    }

    /**
     * Hide tooltip (revert to default)
     */
    hideTooltip() {
        this.setDefaultContent();
    }



    /**
     * Reinitialize tooltip manager (useful when keyboard is shown/hidden)
     */
    reinitialize() {
        this.init();
    }
}

// ===== SVG KEYBOARD INTERACTIVITY =====
class SVGKeyboardManager {
    constructor() {
        this.eventsBound = false;
        this.init();
    }

    /**
     * Initialize SVG keyboard interactivity
     */
    init() {
        console.log('Initializing SVG Keyboard Manager...');
        this.bindSVGKeyboardEvents();
    }

    /**
     * Bind events to SVG keyboard keys
     */
    bindSVGKeyboardEvents() {
        const keyboardContainer = Utils.getElement('.keyboard-container');
        if (!keyboardContainer) {
            console.warn('Keyboard container not found');
            return;
        }

        // Check if events are already bound to avoid duplicates
        if (this.eventsBound) {
            console.log('SVGKeyboardManager: Events already bound, skipping');
            return;
        }

        const svgKeys = keyboardContainer.querySelectorAll('svg rect[id^="key-"]');
        console.log(`Found ${svgKeys.length} SVG keys`);

        svgKeys.forEach(key => {
            // Check if event listeners are already attached
            if (!key.hasAttribute('data-svg-bound')) {
                // Add click event
                key.addEventListener('click', (e) => this.handleKeyClick(e, key));

                // Add hover effects
                key.addEventListener('mouseenter', (e) => this.handleKeyHover(e, key, true));
                key.addEventListener('mouseleave', (e) => this.handleKeyHover(e, key, false));

                // Add active state on mousedown
                key.addEventListener('mousedown', (e) => this.handleKeyPress(e, key, true));
                key.addEventListener('mouseup', (e) => this.handleKeyPress(e, key, false));

                // Prevent context menu on right click
                key.addEventListener('contextmenu', (e) => e.preventDefault());

                key.setAttribute('data-svg-bound', 'true');
            }
        });

        this.eventsBound = true;
        console.log('SVG keyboard events bound successfully');
    }

    /**
     * Handle key click event
     * @param {Event} event - Click event
     * @param {Element} keyElement - Key element
     */
    handleKeyClick(event, keyElement) {
        const keyId = keyElement.id;
        const keyName = keyId.replace('key-', '');

        console.log(`SVG Key clicked: ${keyName}`);

        // Add visual feedback
        this.animateKeyPress(keyElement);

        // You can add more functionality here, like:
        // - Triggering specific actions based on key
        // - Playing sound effects
        // - Sending data to parent application
        this.triggerKeyAction(keyName);
    }

    /**
     * Handle key hover event
     * @param {Event} event - Hover event
     * @param {Element} keyElement - Key element
     * @param {boolean} isEntering - Whether mouse is entering or leaving
     */
    handleKeyHover(event, keyElement, isEntering) {
        const keyId = keyElement.id;
        const keyName = keyId.replace('key-', '');

        if (isEntering) {
            console.log(`SVG Key hover: ${keyName}`);
            // The CSS hover effects will handle the visual changes
        } else {
            // Reset any temporary states if needed
        }
    }

    /**
     * Handle key press event (mousedown/mouseup)
     * @param {Event} event - Mouse event
     * @param {Element} keyElement - Key element
     * @param {boolean} isPressed - Whether key is being pressed
     */
    handleKeyPress(event, keyElement, isPressed) {
        const keyId = keyElement.id;
        const keyName = keyId.replace('key-', '');

        if (isPressed) {
            keyElement.classList.add('key-pressed');
            console.log(`SVG Key pressed: ${keyName}`);
        } else {
            keyElement.classList.remove('key-pressed');
        }
    }

    /**
     * Animate key press
     * @param {Element} keyElement - Key element
     */
    animateKeyPress(keyElement) {
        // Add a temporary class for animation
        keyElement.classList.add('key-clicked');

        // Remove the class after animation
        setTimeout(() => {
            keyElement.classList.remove('key-clicked');
        }, 200);
    }

    /**
     * Trigger action based on key name
     * @param {string} keyName - Name of the key
     */
    triggerKeyAction(keyName) {
        // Get keyboard shortcuts from KeyboardTooltipManager
        const keyboardShortcuts = window.keyboardTooltipManager?.shortcuts || {};

        // Check if this key is in the shortcuts list (should send data)
        if (keyboardShortcuts[keyName]) {
            console.log(`Sending key data to backend: ${keyName}`);

            // Send key data to backend via NuiBridge
            if (window.NuiBridge) {
                window.NuiBridge.emitToBackend('keyboard:keyPressed', {
                    key: keyName,
                    title: this.getKeyTitle(keyName),
                    description: keyboardShortcuts[keyName]
                });
            } else {
                console.warn('NuiBridge not available, cannot send key data');
            }
        }

        // Map key names to actions
        const keyActions = {
            'esc': () => console.log('Escape key action'),
            'f5': () => console.log('F5 key action - Refresh'),
            'tab': () => console.log('Tab key action'),
            'enter': () => console.log('Enter key action'),
            'space': () => console.log('Space key action'),
            'shift-left': () => console.log('Left Shift key action'),
            'shift-right': () => console.log('Right Shift key action'),
            'ctrl-left': () => console.log('Left Ctrl key action'),
            'ctrl-right': () => console.log('Right Ctrl key action'),
            'alt-left': () => console.log('Left Alt key action'),
            'alt-right': () => console.log('Right Alt key action'),
            'win-left': () => console.log('Left Win key action'),
            'win-right': () => console.log('Right Win key action'),
            'caps-lock': () => console.log('Caps Lock key action'),
            'backspace': () => console.log('Backspace key action'),
            'delete': () => console.log('Delete key action'),
            'home': () => console.log('Home key action'),
            'end': () => console.log('End key action'),
            'page-up': () => console.log('Page Up key action'),
            'page-down': () => console.log('Page Down key action'),
            'arrow-up': () => console.log('Arrow Up key action'),
            'arrow-down': () => console.log('Arrow Down key action'),
            'arrow-left': () => console.log('Arrow Left key action'),
            'arrow-right': () => console.log('Arrow Right key action'),
        };

        // Execute action if available
        if (keyActions[keyName]) {
            keyActions[keyName]();
        } else {
            // For letter keys, just log the key
            if (keyName.length === 1) {
                console.log(`Letter key pressed: ${keyName.toUpperCase()}`);
            } else {
                console.log(`Special key pressed: ${keyName}`);
            }
        }
    }

    /**
     * Extract title from keyboard description
     * @param {string} description - Keyboard description
     * @param {string} keyName - Key name for fallback
     * @returns {string} Extracted title
     */
    extractTitleFromDescription(description, keyName) {
        if (!description) return '';

        // Mapping of common patterns to extract titles
        // Order matters: more specific patterns first to avoid false matches
        // (e.g., "microphone" should be checked before "phone")
        const titlePatterns = [
            // Longest/most specific patterns first
            ['volume do microfone', 'Volume do Microfone'],
            ['microphone volume', 'Microphone Volume'],
            ['volumen del micrófono', 'Volumen del Micrófono'],
            ['volume du microphone', 'Volume du Microphone'],
            ['صوت الميكروفون', 'صوت الميكروفون'],
            ['menu principal', 'Menu Principal'],
            ['menú principal', 'Menú Principal'],
            ['main menu', 'Main Menu'],
            ['القائمة الرئيسية', 'القائمة الرئيسية'],
            ['chamado de ajuda', 'Chamado de Ajuda'],
            ['help ticket', 'Help Ticket'],
            ['ticket de ayuda', 'Ticket de Ayuda'],
            ['ticket d\'aide', 'Ticket d\'Aide'],
            ['طلب المساعدة', 'طلب المساعدة'],
            ['hotbar de itens', 'Hotbar de Itens'],
            ['items hotbar', 'Items Hotbar'],
            ['barra de items', 'Barra de Items'],
            ['hotbar des objets', 'Hotbar des Objets'],
            ['شريط العناصر', 'شريط العناصر'],
            ['recarregar arma', 'Recarregar Arma'],
            ['reload weapon', 'Reload Weapon'],
            ['إعادة تعبئة السلاح', 'إعادة تعبئة السلاح'],
            ['increase/decrease', 'Microphone Volume'],
            // Medium patterns
            ['inventário', 'Inventário'],
            ['inventory', 'Inventory'],
            ['inventario', 'Inventario'],
            ['inventaire', 'Inventaire'],
            ['حقيبتك', 'الحقيبة'],
            ['comandos', 'Comandos'],
            ['commands', 'Commands'],
            ['rádio', 'Rádio'],
            ['radio', 'Radio'],
            ['الراديو', 'الراديو'],
            ['recarregar', 'Recarregar Arma'],
            ['recargar', 'Recargar Arma'],
            ['recharger', 'Recharger Arme'],
            ['reload your', 'Reload Weapon'],
            ['reload', 'Reload Weapon'],
            ['mapa', 'Mapa'],
            ['map', 'Map'],
            ['carte', 'Carte'],
            ['الخريطة', 'الخريطة'],
            ['celular', 'Celular'],
            ['téléphone', 'Téléphone'],
            ['الهاتف', 'الهاتف'],
            // Short patterns last (to avoid false matches)
            ['chat', 'Chat'],
            ['الدردشة', 'الدردشة'],
            ['phone', 'Phone']
        ];

        // Try to find a match (case insensitive)
        const lowerDesc = description.toLowerCase();
        for (const [pattern, title] of titlePatterns) {
            if (lowerDesc.includes(pattern)) {
                return title;
            }
        }

        // Fallback: try to extract from common sentence patterns
        // "Use to open your X" -> "X"
        // "Use para abrir o seu X" -> "X"
        // "Use to use the X" -> "X"
        // "Hold to speak on the X" -> "X"
        const regexPatterns = [
            /(?:use\s+(?:to|para)\s+(?:open|abrir)\s+(?:your|the|o)\s+(?:seu\s+)?)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+use\s+(?:the|o)\s+)(.+?)(?:\s|$|\.)/i,
            /(?:hold\s+(?:to|para)\s+speak\s+(?:on|na)\s+(?:the|a)\s+)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+(?:access|acessar)\s+(?:the|a)\s+)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+increase\/decrease\s+)(.+?)(?:\s|$|\.)/i,
            /(?:use\s+(?:to|para)\s+reload\s+(?:your|the|o)\s+(?:seu\s+)?(?:equipped\s+)?)(.+?)(?:\s|$|\.)/i
        ];

        for (const pattern of regexPatterns) {
            const match = description.match(pattern);
            if (match && match[1]) {
                let extracted = match[1].trim();
                // Remove trailing punctuation
                extracted = extracted.replace(/[.,;:!?]$/, '');

                // Special handling for reload/weapon
                if (lowerDesc.includes('reload') && extracted.toLowerCase().includes('weapon')) {
                    return 'Reload Weapon';
                }

                // Capitalize first letter
                if (extracted) {
                    return extracted.charAt(0).toUpperCase() + extracted.slice(1);
                }
            }
        }

        // Final fallback: use hardcoded titles — pick language from description content
        const lang = detectLanguage(description);
        const titlesByLang = {
            ar: {
                'esc': 'القائمة الرئيسية',
                'f5': 'طلب المساعدة',
                'f8': 'الأوامر',
                'tab': 'شريط العناصر',
                'caps-lock': 'الراديو',
                'r': 'إعادة تعبئة السلاح',
                't': 'الدردشة',
                'p': 'الخريطة',
                'k': 'الهاتف',
                'home': 'صوت الميكروفون',
                'quote': 'الحقيبة'
            },
            es: {
                'esc': 'Menú Principal',
                'f5': 'Ticket de Ayuda',
                'f8': 'Comandos',
                'tab': 'Barra de Items',
                'caps-lock': 'Radio',
                'r': 'Recargar Arma',
                't': 'Chat',
                'p': 'Mapa',
                'k': 'Celular',
                'home': 'Volumen del Micrófono',
                'quote': 'Inventario'
            },
            fr: {
                'esc': 'Menu Principal',
                'f5': 'Ticket d\'Aide',
                'f8': 'Commandes',
                'tab': 'Hotbar des Objets',
                'caps-lock': 'Radio',
                'r': 'Recharger Arme',
                't': 'Chat',
                'p': 'Carte',
                'k': 'Téléphone',
                'home': 'Volume du Microphone',
                'quote': 'Inventaire'
            },
            en: {
                'esc': 'Main Menu',
                'f5': 'Help Ticket',
                'f8': 'Commands',
                'tab': 'Items Hotbar',
                'caps-lock': 'Radio',
                'r': 'Reload Weapon',
                't': 'Chat',
                'p': 'Map',
                'k': 'Phone',
                'home': 'Microphone Volume',
                'quote': 'Inventory'
            },
            pt: {
                'esc': 'Menu Principal',
                'f5': 'Chamado de Ajuda',
                'f8': 'Comandos',
                'tab': 'Hotbar de Itens',
                'caps-lock': 'Rádio',
                'r': 'Recarregar Arma',
                't': 'Chat',
                'p': 'Mapa',
                'k': 'Celular',
                'home': 'Volume do Microfone',
                'quote': 'Inventário'
            }
        };
        const fallbackTitles = titlesByLang[lang] || titlesByLang.pt;
        return fallbackTitles[keyName] || '';
    }

    /**
     * Get title for a key (matching KeyboardTooltipManager format)
     * @param {string} keyName - Key name
     * @returns {string} Key title
     */
    getKeyTitle(keyName) {
        // Try to get title from keyboard description first
        if (window.keyboardTooltipManager && window.keyboardTooltipManager.shortcuts && window.keyboardTooltipManager.shortcuts[keyName]) {
            const extracted = this.extractTitleFromDescription(window.keyboardTooltipManager.shortcuts[keyName], keyName);
            if (extracted) {
                return extracted;
            }
        }

        // Fallback to hardcoded titles
        const titles = {
            'esc': 'Menu Principal',
            'f5': 'Chamado de Ajuda',
            'f8': 'Comandos',
            'tab': 'Hotbar de Itens',
            'caps-lock': 'Rádio',
            'r': 'Recarregar Arma',
            't': 'Chat',
            'p': 'Mapa',
            'k': 'Celular',
            'home': 'Volume do Microfone',
            'quote': 'Inventário'
        };
        return titles[keyName] || '';
    }

    /**
     * Highlight specific keys
     * @param {string[]} keyNames - Array of key names to highlight
     */
    highlightKeys(keyNames) {
        keyNames.forEach(keyName => {
            const keyElement = Utils.getElement(`#key-${keyName}`);
            if (keyElement) {
                keyElement.classList.add('key-highlighted');
            }
        });
    }

    /**
     * Remove highlight from all keys
     */
    clearHighlights() {
        const highlightedKeys = Utils.getElements('.key-highlighted');
        highlightedKeys.forEach(key => {
            key.classList.remove('key-highlighted');
        });
    }
}

// ===== SOCIAL LINKS MANAGER =====
// 🔗 Gerenciador de links das redes sociais - tadalas @ https://discord.gg/gCZpDV8GvS
/**
 * Check if a city is Brazilian (Portuguese)
 * @param {string} cityName - Name of the city
 * @returns {boolean} True if city is Brazilian
 */
function isBrazilianCity(cityName) {
    if (!cityName) return false;

    // Get city config to check if it has Portuguese welcome text
    if (typeof cityConfigManager !== 'undefined') {
        const config = cityConfigManager.getCityConfig(cityName);
        if (config && config.staticTexts && config.staticTexts.welcomeText) {
            const welcomeText = config.staticTexts.welcomeText.toLowerCase();
            // Check if welcome text contains Portuguese indicators
            return welcomeText.includes('bem') || welcomeText.includes('bem-vindo');
        }
    }
    return false;
}

/**
 * Open URL using available methods
 * @param {string} url - URL to open
 */
function openUrl(url) {
    if (!url || url === '#' || url.trim() === '') return;

    if (typeof window.invokeNative === 'function') {
        try {
            window.invokeNative('openUrl', url);
            return;
        } catch (err) {
            console.error('invokeNative failed:', err);
        }
    }

    // Fallback to window.open
    try {
        const newWindow = window.open(url, '_blank', 'noopener,noreferrer');
        if (!newWindow || newWindow.closed) {
            // Try alternative method
            const tempLink = document.createElement('a');
            tempLink.href = url;
            tempLink.target = '_blank';
            tempLink.rel = 'noopener noreferrer';
            tempLink.style.display = 'none';
            document.body.appendChild(tempLink);
            tempLink.click();
            setTimeout(() => document.body.removeChild(tempLink), 100);
        }
    } catch (err) {
        console.error('window.open failed:', err);
    }
}

/**
 * Update social media links from handover data
 * @param {Object} socialLinks - Social links configuration object
 * Expected format: { youtube: 'url', instagram: 'url', discord: 'url', tiktok: 'url' }
 * @param {string} cityName - Optional city name to check if it's Brazilian
 */
function updateSocialLinks(socialLinks, cityName) {
    const linkMap = {
        'youtube': 'social-youtube',
        'instagram': 'social-instagram',
        'discord': 'social-discord',
        'tiktok': 'social-tiktok'
    };

    let visibleIconsCount = 0;

    // Se socialLinks não for válido, ocultar todos os ícones
    if (!socialLinks || typeof socialLinks !== 'object') {
        Object.keys(linkMap).forEach(socialName => {
            const linkElement = document.getElementById(linkMap[socialName]);
            if (linkElement) {
                linkElement.style.display = 'none';
            }
        });
        // visibleIconsCount já é 0, então a seção será ocultada abaixo
    } else {
        // Verificar cada rede social e mostrar/ocultar conforme a URL
        Object.keys(linkMap).forEach(socialName => {
            let linkElement = document.getElementById(linkMap[socialName]);
            if (linkElement) {
                const url = socialLinks[socialName];
                // Se a URL estiver vazia, undefined, null ou for apenas '#', ocultar o ícone
                if (url && typeof url === 'string' && url.trim() !== '' && url !== '#') {
                    linkElement.href = url;
                    linkElement.style.display = 'flex';
                    visibleIconsCount++;
                    console.log(`Updated ${socialName} link: ${url}`);

                    // Remover TODOS os listeners antigos clonando o elemento (garante remoção completa)
                    // cloneNode(true) copia filhos mas NÃO copia event listeners
                    if (linkElement.hasAttribute('data-social-listener-added')) {
                        const parent = linkElement.parentNode;
                        const clonedElement = linkElement.cloneNode(true); // true = copiar filhos (mas não listeners)
                        parent.replaceChild(clonedElement, linkElement);
                        // Atualizar referência para o elemento clonado (sem listeners)
                        linkElement = clonedElement;
                    }

                    // Criar novo handler para o link
                    // Usar invokeNative('openUrl', url) como no código que funcionava antes
                    const clickHandler = function (e) {
                        // Obter URL do atributo href ou da variável url
                        const urlToOpen = url || linkElement.href;
                        console.log(`Social link clicked: ${socialName}, URL: ${urlToOpen}`);

                        // Se a URL não é válida, prevenir comportamento padrão
                        if (!urlToOpen || urlToOpen === '#' || urlToOpen.trim() === '' || urlToOpen === window.location.href) {
                            e.preventDefault();
                            e.stopPropagation();
                            console.warn(`Invalid URL for ${socialName}: ${urlToOpen}`);
                            return;
                        }

                        // Prevenir comportamento padrão
                        e.preventDefault();
                        e.stopPropagation();

                        // Garantir que o href está atualizado
                        linkElement.href = urlToOpen;
                        linkElement.target = '_blank';
                        linkElement.rel = 'noopener noreferrer';

                        // Verificar se é cidade BR e se é Instagram, TikTok ou YouTube
                        const isBR = isBrazilianCity(cityName);
                        const shouldOpenTwoLinks = isBR && (socialName === 'instagram' || socialName === 'tiktok' || socialName === 'youtube');

                        if (shouldOpenTwoLinks) {
                            // Obter links da Santa Group do cityConfigManager
                            const santaGroupLinks = (typeof cityConfigManager !== 'undefined' && cityConfigManager.getSantaGroupLinks)
                                ? cityConfigManager.getSantaGroupLinks()
                                : {};

                            const santaLink = santaGroupLinks[socialName];

                            // Abrir primeiro o link da cidade
                            openUrl(urlToOpen);

                            // Abrir o link da Santa Group após um pequeno delay
                            setTimeout(() => {
                                openUrl(santaLink);
                            }, 300);

                            console.log(`Opened two links for ${socialName} (BR city): ${urlToOpen} and ${santaLink}`);
                        } else {
                            // Abrir apenas um link (comportamento normal)
                            openUrl(urlToOpen);
                            console.log(`Opened single link for ${socialName}: ${urlToOpen}`);
                        }
                    };

                    // Armazenar referência do handler e adicionar listener na fase de captura
                    linkElement._socialClickHandler = clickHandler;
                    linkElement.setAttribute('data-social-listener-added', 'true');
                    linkElement.addEventListener('click', clickHandler, true); // true = capture phase
                } else {
                    // Ocultar ícone se não houver URL válida
                    linkElement.style.display = 'none';
                    // Remover listener se existir
                    if (linkElement.hasAttribute('data-social-listener-added')) {
                        const oldHandler = linkElement._socialClickHandler;
                        if (oldHandler) {
                            linkElement.removeEventListener('click', oldHandler);
                        }
                        linkElement.removeAttribute('data-social-listener-added');
                    }
                    console.log(`Hiding ${socialName} icon - no valid URL`);
                }
            }
        });
    }

    // Se não houver nenhum ícone visível, ocultar o título e a seção social
    const socialSection = document.querySelector('.social-section');
    const sectionTitle = document.querySelector('.social-section .section-title');

    if (visibleIconsCount === 0) {
        if (socialSection) {
            socialSection.style.display = 'none';
        }
        if (sectionTitle) {
            sectionTitle.style.display = 'none';
        }
        console.log('Hiding social section - no social links available');
    } else {
        if (socialSection) {
            socialSection.style.display = 'flex';
        }
        if (sectionTitle) {
            sectionTitle.style.display = 'block';
        }
        console.log(`Showing social section - ${visibleIconsCount} social link(s) available`);
    }
}

// ===== INITIALIZE APPLICATION =====
// Create global instance
window.loadingScreenApp = new LoadingScreenApp();

// Initialize SVG Keyboard Manager
window.svgKeyboardManager = new SVGKeyboardManager();

// Initialize Keyboard Tooltip Manager with a small delay to ensure DOM is ready
setTimeout(() => {
    window.keyboardTooltipManager = new KeyboardTooltipManager();

    // Update defaultText from staticTexts if available
    if (window.cityConfigManager && window.nuiHandoverData?.cityName) {
        const cityName = window.nuiHandoverData.cityName;
        const config = window.cityConfigManager.getCityConfig(cityName);
        if (config && config.staticTexts && config.staticTexts.shortcutsDescription) {
            window.keyboardTooltipManager.defaultText = config.staticTexts.shortcutsDescription;
            if (window.keyboardTooltipManager.tooltipDescription) {
                window.keyboardTooltipManager.tooltipDescription.textContent = config.staticTexts.shortcutsDescription;
            }
            console.log('Updated KeyboardTooltipManager defaultText from staticTexts:', config.staticTexts.shortcutsDescription);
        }
    }
}, 500);

// ===== NUI BRIDGE WIRING =====
// Bind backend -> UI events and notify backend when ready
(function wireNuiBridge() {
    if (!window.NuiBridge) return;

    // Loading Screen do FiveM - Lê dados de window.nuiHandoverData
    // Conforme: https://docs.fivem.net/docs/scripting-manual/nui-development/loading-screens/
    // ⚠️ CRÍTICO: Não há client rodando durante a loading screen!
    // Todos os dados vêm via window.nuiHandoverData (enviados via deferrals.handover() no servidor)
    const initLoadingScreen = () => {
        try {
            // Ocultar todos os ícones de redes sociais inicialmente
            updateSocialLinks(null);

            // Ler dados de window.nuiHandoverData (enviados via deferrals.handover() no servidor)
            const handoverData = window.nuiHandoverData || {};

            console.log('Loading screen iniciada. Dados recebidos:', handoverData);
            if (handoverData.serverAddress) {
                console.log('Servidor:', handoverData.serverAddress);
            }

            // Backend now only sends cityName and progress via handoverData
            const cityName = handoverData.cityName || handoverData.City || 'Santa';

            // Only apply city configuration if cityName is provided
            if (cityName) {
                // Atualizar city name
                window.nuiHandoverData = Object.assign({}, window.nuiHandoverData, { cityName });

                // Aplicar todas as configurações da cidade a partir do cityConfigs.js
                if (window.cityConfigManager) {
                    window.cityConfigManager.applyCityConfig(cityName);
                } else {
                    console.error('cityConfigManager not available. Make sure cityConfigs.js is loaded.');
                }
            } else {
                console.warn('No cityName provided in handoverData. City configuration will not be applied.');
            }

            // Aplicar progresso inicial (se enviado pelo backend)
            if (typeof handoverData.progress === 'number') {
                const mgr = window.loadingScreenApp?.progressManager;
                if (mgr) {
                    mgr.progress = Math.max(0, Math.min(100, handoverData.progress));
                    mgr.updateProgressDisplay();
                }
            }

            // Load content
            window.loadingScreenApp?.loadContent();

            console.log('Loading screen configurada! Cidade:', cityName);
        } catch (e) {
            console.error('Erro ao inicializar loading screen:', e);
        }
    };

    // Aguardar DOMContentLoaded (padrão FiveM para loading screens)
    // Conforme: https://docs.fivem.net/docs/scripting-manual/nui-development/loading-screens/
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initLoadingScreen);
    } else {
        // DOM já está pronto
        initLoadingScreen();
    }

    // Music controls
    window.NuiBridge.on('music:play', () => {
        try { window.loadingScreenApp?.musicPlayer?.play(); } catch (e) { console.error(e); }
    });
    window.NuiBridge.on('music:pause', () => {
        try { window.loadingScreenApp?.musicPlayer?.pause(); } catch (e) { console.error(e); }
    });
    window.NuiBridge.on('music:setVolume', (p) => {
        try {
            const v = typeof p?.volume === 'number' ? Math.max(0, Math.min(1, p.volume)) : undefined;
            if (v == null) return;
            const audio = document.getElementById('backgroundMusic');
            if (audio) {
                audio.volume = v;
                // Update MusicPlayer volume property to keep it in sync
                if (window.loadingScreenApp?.musicPlayer) {
                    window.loadingScreenApp.musicPlayer.volume = v;
                }
                // Update volume slider visually at 50% (real volume is set above, visual is separate)
                if (window.updateVolumeSlider) {
                    window.updateVolumeSlider(50);
                }
            }
        } catch (e) { console.error(e); }
    });
    window.NuiBridge.on('music:seek', (p) => {
        try {
            const seconds = Number(p?.seconds);
            const audio = document.getElementById('backgroundMusic');
            if (!audio || !audio.duration || !isFinite(seconds)) return;
            audio.currentTime = Math.max(0, Math.min(audio.duration, seconds));
        } catch (e) { console.error(e); }
    });
    window.NuiBridge.on('music:setUrl', (p) => {
        try {
            const musicUrl = p?.musicUrl;
            if (!musicUrl || typeof musicUrl !== 'string') return;

            const audio = document.getElementById('backgroundMusic');
            if (!audio) return;

            // Pause current music if playing
            if (!audio.paused) {
                audio.pause();
            }

            // Set new source
            const source = audio.querySelector('source');
            if (source) {
                source.src = musicUrl;
                audio.load(); // Reload audio element with new source
            } else {
                audio.src = musicUrl;
            }

            // Auto-play after load
            const tryPlayMusic = () => {
                audio.play().then(() => {
                    console.log('Music auto-played from music:setUrl');
                    // Update music player state if available
                    if (window.loadingScreenApp?.musicPlayer) {
                        window.loadingScreenApp.musicPlayer.isPlaying = true;
                        window.loadingScreenApp.musicPlayer.updatePlayButton();
                    }
                }).catch(err => console.warn('Auto-play prevented:', err));
            };

            if (audio.readyState >= 2) {
                tryPlayMusic();
            } else {
                audio.addEventListener('loadeddata', tryPlayMusic, { once: true });
                audio.addEventListener('canplay', tryPlayMusic, { once: true });
            }
        } catch (e) { console.error(e); }
    });

    // Video controls
    window.NuiBridge.on('video:set', (p) => {
        try {
            const videoUrl = p?.videoUrl;
            if (!videoUrl || typeof videoUrl !== 'string') return;

            // Validate URL is from santaloading.roleplayrp.com or cdn.santagroup.gg
            const lowerVideoUrl = videoUrl.toLowerCase();
            if ((!videoUrl.includes('santaloading.roleplayrp.com') && !videoUrl.includes('cdn.santagroup.gg')) || !(lowerVideoUrl.endsWith('.mp4') || lowerVideoUrl.endsWith('.webm'))) {
                console.warn('Invalid video URL:', videoUrl);
                return;
            }

            const video = document.getElementById('backgroundVideo');
            if (!video) return;

            const source = video.querySelector('source');
            if (source) {
                source.src = videoUrl;
                video.load(); // Reload video element with new source
                video.play().catch(err => console.warn('Video auto-play prevented:', err));
            } else {
                video.src = videoUrl;
                video.load();
                video.play().catch(err => console.warn('Video auto-play prevented:', err));
            }
        } catch (e) { console.error(e); }
    });

    // UI controls
    window.NuiBridge.on('ui:showKeyboard', () => {
        try {
            const app = window.loadingScreenApp;
            const mainContent = document.querySelector('#mainContent');
            if (app && mainContent && !mainContent.classList.contains('show')) app.toggleKeyboard();
        } catch (e) { console.error(e); }
    });
    window.NuiBridge.on('ui:hideKeyboard', () => {
        try {
            const app = window.loadingScreenApp;
            const mainContent = document.querySelector('#mainContent');
            if (app && mainContent && mainContent.classList.contains('show')) app.toggleKeyboard();
        } catch (e) { console.error(e); }
    });

    // City configuration - receive only city name, all configs come from cityConfigs.js
    window.NuiBridge.on('init:loading', (p) => {
        try {
            // Backend now only sends cityName and progress
            const cityName = p?.cityName || p?.City;

            if (!cityName) {
                console.warn('City name not provided in init:loading event');
                return;
            }

            // Update city name in handover data
            window.nuiHandoverData = Object.assign({}, window.nuiHandoverData, { cityName });

            // Apply all city configurations from cityConfigs.js
            if (window.cityConfigManager) {
                window.cityConfigManager.applyCityConfig(cityName);
            } else {
                console.error('cityConfigManager not available. Make sure cityConfigs.js is loaded.');
            }

            // Load content
            window.loadingScreenApp?.loadContent();

            console.log('City configuration applied for:', cityName);
        } catch (e) {
            console.error('Error applying city configuration:', e);
        }
    });

    // Progresso vem automaticamente do FiveM via evento loadProgress
    // Escutar evento automático do FiveM
    window.addEventListener('message', (event) => {
        try {
            if (event.data?.eventName === 'loadProgress') {
                const loadFraction = event.data?.loadFraction;
                if (typeof loadFraction === 'number') {
                    // Converter de 0.0-1.0 para 0-100
                    const progress = Math.round(loadFraction * 100);
                    const mgr = window.loadingScreenApp?.progressManager;
                    if (mgr) {
                        mgr.progress = Math.max(0, Math.min(100, progress));
                        mgr.updateProgressDisplay();
                    }
                }
            }
        } catch (e) { console.error(e); }
    });

    // Handler progress:set ainda existe para compatibilidade (caso seja usado depois que scripts iniciarem)
    window.NuiBridge.on('progress:set', (p) => {
        try {
            const val = Number(p?.value);
            const mgr = window.loadingScreenApp?.progressManager;
            if (!mgr || !isFinite(val)) return;
            mgr.progress = Math.max(0, Math.min(100, val));
            mgr.updateProgressDisplay();
        } catch (e) { console.error(e); }
    });

    // Slides configuration
    window.NuiBridge.on('slides:set', (p) => {
        try {
            const slides = p?.slides;
            if (!Array.isArray(slides) || slides.length === 0) return;

            const app = window.loadingScreenApp;
            if (!app || !app.vipSlider) return;

            // Destroy existing slides
            app.vipSlider.destroy();
            app.vipSlider.slides = [];
            app.vipSlider.slidesData = [];
            app.vipSlider.currentSlide = 0;

            // Create new slides from backend data
            slides.forEach((slideData, index) => {
                if (!slideData?.image) return;

                // Store slide data for title/description updates
                app.vipSlider.slidesData.push({
                    title: slideData.title || '',
                    description: slideData.description || '',
                    image: slideData.image,
                    alt: slideData.alt,
                    city: slideData.city
                });

                const slide = document.createElement('div');
                slide.className = 'slider-slide';
                slide.dataset.index = index;

                const img = document.createElement('img');
                img.src = slideData.image;
                img.alt = slideData.alt || slideData.city || `Slide ${index + 1}`;
                img.onerror = () => {
                    console.warn(`Failed to load slide image: ${slideData.image}`);
                    slide.style.display = 'none';
                };

                const overlay = document.createElement('div');
                overlay.className = 'slider-overlay';

                slide.appendChild(img);
                slide.appendChild(overlay);
                app.vipSlider.sliderTrack.appendChild(slide);
                app.vipSlider.slides.push(slide);
            });

            // Update pagination, content and restart autoplay
            if (app.vipSlider.slides.length > 0) {
                app.vipSlider.createPaginationDots();
                app.vipSlider.updateSlideContent(); // Update title/description for initial slide
                app.vipSlider.startAutoPlay();
            }
        } catch (e) { console.error(e); }
    });
})();

// ===== ENHANCED SHORTCUTS FUNCTIONALITY =====
document.addEventListener('DOMContentLoaded', function () {
    console.log('DOM loaded, enhanced shortcuts functionality ready...');

    // ===== SIMPLE VOLUME CONTROL =====
    console.log('Setting up simple volume control...');

    function setupVolumeControl() {
        const volumeBtn = document.getElementById('volumeBtn');
        const volumeSliderContainer = document.getElementById('volumeSliderContainer');
        const volumeSlider = document.getElementById('volumeSlider');

        if (!volumeBtn || !volumeSliderContainer || !volumeSlider) {
            console.log('Volume elements not found, retrying...');
            setTimeout(setupVolumeControl, 500);
            return;
        }

        console.log('Volume elements found, setting up control');

        // Remove any existing event listeners
        const newVolumeBtn = volumeBtn.cloneNode(true);
        volumeBtn.parentNode.replaceChild(newVolumeBtn, volumeBtn);

        // Volume button click handler
        newVolumeBtn.addEventListener('click', function (e) {
            console.log('Volume button clicked!');
            e.preventDefault();
            e.stopPropagation();

            const isVisible = volumeSliderContainer.classList.contains('show');
            console.log('Volume slider currently visible:', isVisible);
            console.log('Volume slider container:', volumeSliderContainer);

            if (isVisible) {
                console.log('Hiding volume slider');
                volumeSliderContainer.classList.remove('show');
                newVolumeBtn.classList.remove('active');
                setTimeout(() => {
                    if (!volumeSliderContainer.classList.contains('show')) {
                        volumeSliderContainer.style.display = 'none';
                    }
                }, 300);
            } else {
                console.log('Showing volume slider');
                volumeSliderContainer.classList.add('show');
                newVolumeBtn.classList.add('active');
                volumeSliderContainer.style.display = 'flex';

                // Initialize volume slider when shown - always show 50% visually
                setTimeout(() => {
                    const volumeThumb = document.getElementById('volume-thumb');
                    if (volumeThumb) {
                        // Always show 50% visually for better UX indication
                        // Real volume is not changed
                        updateVolumeSlider(50);
                        console.log('Volume slider shown at 50% (visual only)');
                    }
                }, 100);

                console.log('Volume slider classes after show:', volumeSliderContainer.className);
                console.log('Volume slider style after show:', volumeSliderContainer.style.cssText);
            }
        });

        // Volume slider SVG click handler
        volumeSlider.addEventListener('click', function (e) {
            const rect = volumeSlider.getBoundingClientRect();
            const y = e.clientY - rect.top;
            const percentage = Math.max(0, Math.min(100, (1 - y / rect.height) * 100));

            console.log('Volume changed to:', percentage + '%');

            // Update audio volume if available
            const audio = document.getElementById('backgroundMusic');
            if (audio) {
                const volumeValue = percentage / 100;
                audio.volume = volumeValue;
                // Update MusicPlayer volume property to keep it in sync
                if (window.loadingScreenApp?.musicPlayer) {
                    window.loadingScreenApp.musicPlayer.volume = volumeValue;
                }
            }

            // Update visual elements
            updateVolumeSlider(percentage);
        });

        // Volume slider SVG mouse move handler for dragging
        let isDragging = false;

        volumeSlider.addEventListener('mousedown', function (e) {
            e.preventDefault();
            isDragging = true;
            updateVolumeFromMouse(e);
            console.log('Volume dragging started');
        });

        volumeSlider.addEventListener('mousemove', function (e) {
            if (isDragging) {
                e.preventDefault();
                updateVolumeFromMouse(e);
            }
        });

        volumeSlider.addEventListener('mouseup', function (e) {
            if (isDragging) {
                e.preventDefault();
                isDragging = false;
                console.log('Volume dragging ended');
            }
        });

        // Also listen on document for when mouse leaves the slider
        document.addEventListener('mousemove', function (e) {
            if (isDragging) {
                updateVolumeFromMouse(e);
            }
        });

        document.addEventListener('mouseup', function () {
            if (isDragging) {
                isDragging = false;
                console.log('Volume dragging ended (document)');
            }
        });

        function updateVolumeFromMouse(e) {
            const rect = volumeSlider.getBoundingClientRect();
            const y = e.clientY - rect.top;
            const percentage = Math.max(0, Math.min(100, (1 - y / rect.height) * 100));

            console.log(`Mouse Y: ${y}, Rect height: ${rect.height}, Percentage: ${percentage}%`);

            // Update audio volume if available
            const audio = document.getElementById('backgroundMusic');
            if (audio) {
                const volumeValue = percentage / 100;
                audio.volume = volumeValue;
                // Update MusicPlayer volume property to keep it in sync
                if (window.loadingScreenApp?.musicPlayer) {
                    window.loadingScreenApp.musicPlayer.volume = volumeValue;
                }
            }

            // Update visual elements
            updateVolumeSlider(percentage);
        }

        function updateVolumeSlider(percentage) {
            const thumb = document.getElementById('volume-thumb');
            const fill = document.getElementById('volume-fill');

            if (thumb && fill) {
                // Ensure percentage is within valid range
                const clampedPercentage = Math.max(0, Math.min(100, percentage));

                // Calculate position (0% = bottom, 100% = top)
                const trackHeight = 50; // Height of the track area
                const trackTop = 2; // Top position of track
                const trackBottom = trackTop + trackHeight; // Bottom position of track

                // Calculate fill properties first
                const fillHeight = (clampedPercentage / 100) * trackHeight;
                const fillY = trackBottom - fillHeight;

                // Calculate thumb position - it should be at the top of the fill
                const thumbY = Math.max(trackTop + 1.5, Math.min(trackBottom - 1.5, fillY + 1.5));

                // Update thumb position (circle uses cx and cy) - centered horizontally
                thumb.setAttribute('cx', '4.5');
                thumb.setAttribute('cy', thumbY);

                // Update fill height and position
                fill.setAttribute('y', Math.max(trackTop, fillY));
                fill.setAttribute('height', Math.max(0, fillHeight));

                // Make sure thumb is always visible
                thumb.style.display = 'block';
                thumb.style.opacity = '1';
            }
        }

        // Make updateVolumeSlider globally accessible so it can be called from anywhere
        window.updateVolumeSlider = updateVolumeSlider;

        // Initialize volume slider with 50% visual (but keep real volume unchanged)
        function initializeVolumeSlider() {
            const audio = document.getElementById('backgroundMusic');
            if (audio) {
                // Always show 50% visually for better UX indication that sound is playing
                // But don't change the actual volume
                updateVolumeSlider(50);
            } else {
                // If audio not ready, try again after a short delay
                setTimeout(initializeVolumeSlider, 200);
            }
        }

        // Initialize immediately and also when audio is ready
        initializeVolumeSlider();
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeVolumeSlider);
        }

        // Close slider when clicking outside
        document.addEventListener('click', function (e) {
            if (!volumeBtn.contains(e.target) && !volumeSliderContainer.contains(e.target)) {
                volumeSliderContainer.classList.remove('show');
                newVolumeBtn.classList.remove('active');
                setTimeout(() => {
                    if (!volumeSliderContainer.classList.contains('show')) {
                        volumeSliderContainer.style.display = 'none';
                    }
                }, 300);
            }
        });

        console.log('Volume control setup complete');
    }

    // Start setup
    setupVolumeControl();

    // ===== PROGRESS BAR INTERACTIVITY =====
    function setupProgressBarInteractivity() {
        const progressBar = document.getElementById('trackProgress');

        if (!progressBar) {
            console.log('Progress bar not found, retrying...');
            setTimeout(setupProgressBarInteractivity, 500);
            return;
        }

        console.log('Progress bar found, setting up interactivity');

        // Click handler for progress bar
        progressBar.addEventListener('click', function (e) {
            const rect = progressBar.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const percentage = Math.max(0, Math.min(100, (x / rect.width) * 100));

            console.log('Progress bar clicked at:', percentage + '%');

            // Update audio position if available
            const audio = document.getElementById('backgroundMusic');
            if (audio && audio.duration) {
                audio.currentTime = (percentage / 100) * audio.duration;
            }
        });

        // Mouse move handler for dragging
        let isDragging = false;
        progressBar.addEventListener('mousedown', function (e) {
            isDragging = true;
            updateProgressFromMouse(e);
        });

        document.addEventListener('mousemove', function (e) {
            if (isDragging) {
                updateProgressFromMouse(e);
            }
        });

        document.addEventListener('mouseup', function () {
            isDragging = false;
        });

        function updateProgressFromMouse(e) {
            const rect = progressBar.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const percentage = Math.max(0, Math.min(100, (x / rect.width) * 100));

            // Update audio position if available
            const audio = document.getElementById('backgroundMusic');
            if (audio && audio.duration) {
                audio.currentTime = (percentage / 100) * audio.duration;
            }
        }

        // Initialize progress bar position
        initializeProgressBar();

        console.log('Progress bar interactivity setup complete');
    }

    function initializeProgressBar() {
        const progressFill = document.getElementById('progress-fill');
        const progressThumb = document.getElementById('progress-thumb');

        if (progressFill && progressThumb) {
            // Set initial position (0%)
            progressFill.setAttribute('width', '0');
            progressThumb.setAttribute('x', '2.5'); // Center the thumb at the start
        }

        // Initialize volume slider
        const volumeThumb = document.getElementById('volume-thumb');
        if (volumeThumb) {
            // Set initial volume to 50% and make thumb visible
            updateVolumeSlider(50);
            console.log('Volume slider initialized with 50%');
        } else {
            console.log('Volume thumb not found!');
        }
    }

    // Start progress bar setup
    setupProgressBarInteractivity();
});

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
    module.exports = LoadingScreenApp;
}

/*
🎯 DUMPOU? GOSTOU? QUER ALGO DO CRIADOR DO MESMO? 
👨‍💻 CRIADO POR: tadalas
🔗 DISCORD: https://discord.gg/gCZpDV8GvS

⚠️ ATENÇÃO DUMPERS: Este código está protegido!
🏢 SISTEMA EXCLUSIVO DA SANTA GROUP - USO PROIBIDO FORA DA REDE
Se você está tentando roubar ou modificar este sistema, 
saiba que suas ações são ilegais e serão rastreadas.
Entre em contato no Discord se quiser usar legalmente criando um proprio.

Este é um sistema de loading screen completo e otimizado para FiveM.
Todas as funcionalidades foram desenvolvidas do zero com foco em performance e UX.
*/