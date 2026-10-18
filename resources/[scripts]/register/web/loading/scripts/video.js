/**
 * Video Manager
 * Handles background video loading and playback
 */

class VideoManager {
    constructor() {
        this.video = null;
        this.videoUrl = '';
        this.cityName = '';
        this.isLoaded = false;
        this.loadAttempts = 0;
        this.maxLoadAttempts = 3;
        this.loadTimeout = null;
        this.timeoutDuration = 8000;
        
        this.init();
    }

    /**
     * Initialize video manager
     */
    init() {
        this.video = document.getElementById('backgroundVideo');
        if (!this.video) {
            console.error('Background video element not found');
            return;
        }

        this.bindEvents();
        this.waitForCityData();
    }

    /**
     * Wait for city data to be available
     */
    waitForCityData() {
        const checkCityData = () => {
            if (window.nuiHandoverData?.cityName) {
                this.cityName = window.nuiHandoverData.cityName;
                this.loadVideo();
            } else {
                setTimeout(checkCityData, 500);
            }
        };
        checkCityData();
    }

    /**
     * Load video for current city
     */
    loadVideo() {
        console.log('Loading video for city:', this.cityName);
        
        // Get video URL from city configs
        this.videoUrl = this.getVideoUrl();
        
        if (!this.videoUrl) {
            console.error('No video URL found for city:', this.cityName);
            this.hideVideoBackground();
            return;
        }

        this.setupLoadTimeout();
        this.startVideoLoad();
    }

    /**
     * Get video URL for current city
     * @returns {string|null} Video URL or null
     */
    getVideoUrl() {
        // Try new city config manager first
        if (window.cityConfigManager) {
            const videoUrl = window.cityConfigManager.getVideoUrl(this.cityName);
            if (videoUrl && this.isValidLocalVideo(videoUrl)) {
                return videoUrl;
            }
        }
        
        // Fallback to legacy config
        if (window.cityConfigs) {
            const videoUrl = window.cityConfigs[this.cityName];
            if (videoUrl && this.isValidLocalVideo(videoUrl)) {
                return videoUrl;
            }
        }
        
        return null;
    }

    /**
     * Validate if URL is a local MP4 video
     * @param {string} url - Video URL to validate
     * @returns {boolean} True if valid local MP4
     */
    isValidLocalVideo(url) {
        if (!url || typeof url !== 'string') return false;

        const lower = url.toLowerCase();
        const hasValidExt = lower.endsWith('.mp4') || lower.endsWith('.webm');
        const isLocalCdn = url.includes('santaloading.roleplayrp.com') || url.includes('cdn.santagroup.gg');

        return hasValidExt && isLocalCdn;
    }

    /**
     * Setup loading timeout
     */
    setupLoadTimeout() {
        this.clearLoadTimeout();
        
        this.loadTimeout = setTimeout(() => {
            if (!this.isLoaded && this.loadAttempts >= this.maxLoadAttempts) {
                console.log('Video loading timeout - hiding video background');
                this.hideVideoBackground();
            } else if (!this.isLoaded) {
                this.loadAttempts++;
                console.log(`Video load attempt ${this.loadAttempts} of ${this.maxLoadAttempts}`);
                this.startVideoLoad();
            }
        }, this.timeoutDuration);
    }

    /**
     * Clear loading timeout
     */
    clearLoadTimeout() {
        if (this.loadTimeout) {
            clearTimeout(this.loadTimeout);
            this.loadTimeout = null;
        }
    }

    /**
     * Start video loading process
     */
    startVideoLoad() {
        if (this.isLoaded) {
            console.log('Video already loaded');
            return;
        }

        if (!this.isValidLocalVideo(this.videoUrl)) {
            console.error('Invalid video URL - only local MP4 files are allowed:', this.videoUrl);
            this.handleVideoError();
            return;
        }

        // Check if video is already loaded with the same URL to prevent duplicate loading
        const currentSrc = this.video.src || (this.video.querySelector('source')?.src);
        if (currentSrc && currentSrc === this.videoUrl) {
            console.log('Video already has the same URL, skipping duplicate load:', this.videoUrl);
            // If video is already loaded but not marked as loaded, mark it
            if (this.video.readyState >= 2) { // HAVE_CURRENT_DATA or higher
                this.isLoaded = true;
                this.clearLoadTimeout();
            }
            return;
        }

        try {
            console.log('Loading local MP4 video:', this.videoUrl);
            this.video.src = this.videoUrl;
            this.video.load();
        } catch (error) {
            console.error('Error starting video load:', error);
            this.handleVideoError();
        }
    }

    /**
     * Bind video events
     */
    bindEvents() {
        if (!this.video) return;

        this.video.addEventListener('loadeddata', () => this.onVideoLoaded());
        this.video.addEventListener('canplay', () => this.onVideoCanPlay());
        this.video.addEventListener('error', () => this.handleVideoError());
        this.video.addEventListener('ended', () => this.onVideoEnded());
    }

    /**
     * Handle video loaded event
     */
    onVideoLoaded() {
        console.log('Video data loaded successfully');
        this.isLoaded = true;
        this.clearLoadTimeout();
        
        // Try to play the video
        this.playVideo().catch(error => {
            console.error('Error playing video:', error);
            // Still mark as loaded even if autoplay fails
            this.isLoaded = true;
            this.clearLoadTimeout();
        });
    }

    /**
     * Handle video can play event
     */
    onVideoCanPlay() {
        console.log('Video can start playing');
        this.notifyContentLoaded();
    }

    /**
     * Handle video error
     */
    handleVideoError() {
        console.error('Video loading error');
        this.loadAttempts++;
        
        if (this.loadAttempts >= this.maxLoadAttempts) {
            this.hideVideoBackground();
        } else {
            // Retry loading after delay
            setTimeout(() => this.startVideoLoad(), 1000);
        }
    }

    /**
     * Handle video ended event
     */
    onVideoEnded() {
        // Restart video for loop effect
        this.video.currentTime = 0;
        this.playVideo().catch(error => {
            console.error('Error restarting video:', error);
        });
    }

    /**
     * Play video
     * @returns {Promise} Promise that resolves when video starts playing
     */
    playVideo() {
        return this.video.play();
    }

    /**
     * Hide video background
     */
    hideVideoBackground() {
        const videoBackground = document.querySelector('.video-background');
        if (videoBackground) {
            videoBackground.style.display = 'none';
        }
        
        // Set fallback background
        document.body.style.backgroundColor = '#000000';
        
        this.notifyContentLoaded();
    }

    /**
     * Notify that content is loaded
     */
    notifyContentLoaded() {
        // Call global function if it exists
        if (typeof window.loadingScreenApp?.showLoadedContent === 'function') {
            window.loadingScreenApp.showLoadedContent();
        }
    }

    /**
     * Get video loading status
     * @returns {boolean} True if video is loaded
     */
    isVideoLoaded() {
        return this.isLoaded;
    }

    /**
     * Get current city name
     * @returns {string} Current city name
     */
    getCurrentCity() {
        return this.cityName;
    }

    /**
     * Reload video for new city
     * @param {string} cityName - New city name
     */
    reloadForCity(cityName) {
        this.cityName = cityName;
        this.isLoaded = false;
        this.loadAttempts = 0;
        this.clearLoadTimeout();
        this.loadVideo();
    }
}

// Initialize video manager when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.videoManager = new VideoManager();
});

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
    module.exports = VideoManager;
}