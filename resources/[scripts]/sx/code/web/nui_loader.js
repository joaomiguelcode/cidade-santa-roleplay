/**
 * nui_loader.js — Runtime bootstrap for NUI bundles from Cloudflare Pages.
 *
 * Loaded via bootstrap.html (ui_page '@sx/code/web/bootstrap.html').
 * Reads convars natively, fetches the Vite manifest from the CDN,
 * injects script + CSS tags, and reloads in-place when ui_branch changes.
 *
 * ES5-compatible, no bundler, no external dependencies.
 */
(function ()
{
    'use strict';

    var LOG_PREFIX = '[nui_loader]';
    var T0 = (typeof performance !== 'undefined' && performance.now) ? performance.now() : Date.now();

    var emit     = window.__nuiLoaderEmit    || function () {};
    var setWide  = window.__nuiLoaderSetWide || function () {};
    var incWide  = window.__nuiLoaderIncWide || function () {};
    var nowMs    = window.__nuiLoaderNowMs   || function () { return 0; };
    var wide     = window.__nuiLoaderWide    || {};


    console.log(LOG_PREFIX, 'Initializing...');

    var FETCH_TIMEOUT_MS = 5000;
    var DEFAULT_CDN_BASE = 'santa-ui.pages.dev';
    var PROD_HOST        = 'frontend.santagroup.gg';
    var MANIFEST_PATHS = ['.vite/manifest.json', 'manifest.json'];

    // Messages sent by nui.lua's bootstrap bridge; any other message type means
    // a game resource is actively trying to open its UI, so loader failures
    // become user-visible (escalate the diagnostic to full-screen).
    var BOOTSTRAP_MESSAGE_TYPES = { bootstrapReady: 1, convarsSet: 1, convarSet: 1, setWide: 1 };

    var resource = window.GetParentResourceName
        ? window.GetParentResourceName()
        : 'unknown';

    console.log(LOG_PREFIX, 'Resource:', resource);

    var convars = {};
    var injectedElements = [];
    var currentUrl = null;
    var initialized = false;
    var convarsReady = null; // Promise that resolves once the initial convar payload is in
    var uiWasPrompted = false; // Flipped by the first non-bootstrap NUI message we receive
    var lastDiagnosticError = null; // Retained so we can re-render if/when we escalate the overlay

    // ── Convar helpers ──────────────────────────────────────────────

    function getConvar( name )
    {
        return convars[ name ] || '';
    }

    var FETCH_RETRY_BASE_MS = 50;
    var FETCH_RETRY_MAX_MS  = 1000;
    var FETCH_RETRY_GIVEUP_MS = 10000;

    function fetchConvars( attempt )
    {
        attempt = attempt || 1;
        incWide( 'convars_attempts', 1 );

        var fetchT0 = (typeof performance !== 'undefined' && performance.now) ? performance.now() : Date.now();

        console.log(LOG_PREFIX, 'fetchConvars() attempt #' + attempt + ' → POST https://' + resource + '/getConvars');

        var promise = fetch( 'https://' + resource + '/getConvars', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ traceId: window.__nuiLoaderTraceId || '' }),
        })
        .then( function ( res )
        {
            console.log(LOG_PREFIX, 'getConvars HTTP response status=' + res.status + ' ok=' + res.ok + ' (attempt #' + attempt + ')');
            setWide({ convars_last_http_status: res.status });

            if ( !res.ok )
            {
                // 404 typically means the Lua-side RegisterNUICallback hasn't run yet
                throw new Error( 'HTTP ' + res.status + ' (callback not registered yet?)' );
            }

            return res.json();
        })
        .then( function ( data )
        {
            var now = (typeof performance !== 'undefined' && performance.now) ? performance.now() : Date.now();
            var roundTrip = Math.round( now - fetchT0 );

            console.log(LOG_PREFIX, 'Convars received (round-trip ' + roundTrip + 'ms):', JSON.stringify( data ));

            var dataKeys = Object.keys( data );
            console.log(LOG_PREFIX, 'Convars data: ' + dataKeys.length + ' key(s) → [' + dataKeys.join( ',' ) + ']');
            for ( var k = 0; k < dataKeys.length; k++ )
            {
                console.log(LOG_PREFIX, '  ' + dataKeys[ k ] + ' = "' + data[ dataKeys[ k ] ] + '"');
            }

            // Merge so any convarSet deltas that arrived mid-fetch aren't clobbered
            var keys = Object.keys( data );
            var preExisting = [];
            for ( var i = 0; i < keys.length; i++ )
            {
                if ( convars[ keys[ i ] ] === undefined )
                {
                    convars[ keys[ i ] ] = data[ keys[ i ] ];
                }
                else
                {
                    preExisting.push( keys[ i ] );
                }
            }

            if ( preExisting.length > 0 )
            {
                console.log(LOG_PREFIX, 'Skipped (already set by convarSet delta during fetch):', preExisting.join( ',' ));
            }

            setWide({
                ui_page_name: getUiPageName(),
                ui_branch:    getConvar( 'ui_branch' ),
                ui_cdn_base:  getConvar( 'ui_cdn_base' ),
                t_convars_received_ms:    nowMs(),
                convars_total_elapsed_ms: roundTrip
            });
            emit( 'nui_loader.convars_received', {} );

            if ( !initialized )
            {
                console.log(LOG_PREFIX, 'Convars ready → triggering initial loadBundle()');
                initialized = true;
                loadBundle();
            }
            else
            {
                console.log(LOG_PREFIX, 'Convars ready, but loadBundle() already triggered earlier (by convarsSet message)');
            }
        })
        .catch( function ( err )
        {
            var now = (typeof performance !== 'undefined' && performance.now) ? performance.now() : Date.now();
            var totalElapsed = now - T0;

            console.warn(LOG_PREFIX, 'fetchConvars attempt #' + attempt + ' FAILED after ' + Math.round( now - fetchT0 ) + 'ms:', err && err.message ? err.message : err);

            if ( totalElapsed >= FETCH_RETRY_GIVEUP_MS )
            {
                console.error(LOG_PREFIX, 'fetchConvars giving up after ' + Math.round( totalElapsed ) + 'ms');
                setWide({
                    last_error_stage:         'convars',
                    convars_total_elapsed_ms: Math.round( totalElapsed )
                });
                showDiagnostic( 'Failed to fetch convars after ' + attempt + ' attempts: ' + ( err.message || err ) );
                return;
            }

            // Exponential backoff capped at FETCH_RETRY_MAX_MS
            var delay = Math.min( FETCH_RETRY_BASE_MS * Math.pow( 2, attempt - 1 ), FETCH_RETRY_MAX_MS );
            console.log(LOG_PREFIX, 'Retrying fetchConvars in ' + delay + 'ms...');

            setTimeout( function () { fetchConvars( attempt + 1 ); }, delay );
        });

        convarsReady = promise;
        return promise;
    }

    // ── URL computation ─────────────────────────────────────────────

    var CF_BRANCH_MAX_LENGTH = 28;

    /**
     * Normalize a git branch name to match CF Pages subdomain format:
     * lowercase, non-alphanumeric → hyphen, collapse hyphens, trim, clamp 28 chars.
     */
    function normalizeBranch( branch )
    {
        return branch
            .toLowerCase()
            .replace( /[^a-z0-9-]/g, '-' )
            .replace( /-+/g, '-' )
            .replace( /^-|-$/g, '' )
            .slice( 0, CF_BRANCH_MAX_LENGTH );
    }

    function getUiPageName()
    {
        return getConvar( 'ui_page_name' ) || resource;
    }

    function computeBaseUrl()
    {
        var uiPageName    = getUiPageName();
        var localOverride = getConvar( 'ui_local_' + uiPageName );

        if ( localOverride )
        {
            return localOverride.replace( /\/+$/, '' );
        }

        var branch  = normalizeBranch( getConvar( 'ui_branch' ) || 'main' );
        var cdnBase = getConvar( 'ui_cdn_base' )  || DEFAULT_CDN_BASE;

        // main is served at the prod host; other branches live on CF Pages previews
        var host = branch === 'main' ? PROD_HOST : branch + '.' + cdnBase;

        return 'https://' + host + '/' + uiPageName;
    }

    function isLocalUrl( url )
    {
        return /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?/i.test( url );
    }

    // ── DOM injection ───────────────────────────────────────────────

    function clearInjected()
    {
        for ( var i = 0; i < injectedElements.length; i++ )
        {
            var el = injectedElements[ i ];

            if ( el && el.parentNode )
            {
                el.parentNode.removeChild( el );
            }
        }

        injectedElements = [];
        setWide({ injected_count: 0 });
    }

    function injectCss( href )
    {
        console.log(LOG_PREFIX, 'Injecting CSS:', href);

        var link  = document.createElement( 'link' );
        link.rel  = 'stylesheet';
        link.href = href;
        link.onload  = function () { console.log(LOG_PREFIX, 'CSS loaded:', href); };
        link.onerror = function () { console.error(LOG_PREFIX, 'CSS failed to load:', href); };

        document.head.appendChild( link );
        injectedElements.push( link );
        incWide( 'injected_count', 1 );
    }

    function injectScript( src, isModule )
    {
        console.log(LOG_PREFIX, 'Injecting script:', src, isModule ? '(module)' : '');

        var script  = document.createElement( 'script' );
        script.src  = src;
        script.onload  = function () { console.log(LOG_PREFIX, 'Script loaded:', src); };
        script.onerror = function () { console.error(LOG_PREFIX, 'Script failed to load:', src); };

        if ( isModule )
        {
            script.type = 'module';
        }

        document.body.appendChild( script );
        injectedElements.push( script );
        incWide( 'injected_count', 1 );
    }

    // ── Manifest parsing ────────────────────────────────────────────

    function resolveEntry( manifest )
    {
        // Vite 5+: keyed by source path, look for isEntry
        var keys = Object.keys( manifest );

        for ( var i = 0; i < keys.length; i++ )
        {
            var entry = manifest[ keys[ i ] ];

            if ( entry.isEntry )
            {
                return entry;
            }
        }

        // Vite 4 flat: try common entry names
        var fallbacks = ['index.html', 'src/main.tsx', 'src/main.ts', 'src/main.jsx', 'src/main.js'];

        for ( var j = 0; j < fallbacks.length; j++ )
        {
            if ( manifest[ fallbacks[ j ] ] )
            {
                return manifest[ fallbacks[ j ] ];
            }
        }

        // Last resort: first entry
        return manifest[ keys[ 0 ] ] || null;
    }

    function injectFromManifest( baseUrl, manifest )
    {
        var entry = resolveEntry( manifest );

        if ( !entry )
        {
            showDiagnostic( 'No entry found in manifest' );
            return;
        }

        // Inject CSS files
        var cssFiles = entry.css || [];

        for ( var i = 0; i < cssFiles.length; i++ )
        {
            injectCss( baseUrl + '/' + cssFiles[ i ] );
        }

        // Inject the main JS bundle
        if ( entry.file )
        {
            injectScript( baseUrl + '/' + entry.file, true );
        }

        setWide({ t_bundle_injected_ms: nowMs(), entry_file: entry.file || '' });
        emit( 'nui_loader.bundle_injected', {} );
    }

    // ── HMR mode (localhost) ────────────────────────────────────────

    function injectHmr( baseUrl )
    {
        injectScript( baseUrl + '/@vite/client', true );
        injectScript( baseUrl + '/src/main.tsx', true );
    }

    // ── Diagnostic overlay ──────────────────────────────────────────

    var diagnosticEl = null;

    function showDiagnostic( errorMsg )
    {
        var fullScreen = uiWasPrompted;
        var reason = 'unknown';
        if ( /convars/i.test( errorMsg ) )                             reason = 'convars';
        else if ( /not found at any expected path/i.test( errorMsg ) ) reason = 'manifest_not_found';
        else if ( /No entry found/i.test( errorMsg ) )                 reason = 'manifest_entry_missing';
        else                                                           reason = 'manifest_fetch_error';

        setWide({
            diagnostic_visible: true,
            last_error_stage:   reason,
            last_error_message: errorMsg
        });
        emit( 'nui_loader.failed', { reason: reason, message: errorMsg, url: currentUrl || '' } );

        if ( !diagnosticEl )
        {
            diagnosticEl = document.createElement( 'div' );
            diagnosticEl.__fullScreen = fullScreen;

            if ( fullScreen )
            {
                diagnosticEl.style.cssText = [
                    'position:fixed',
                    'top:0',
                    'left:0',
                    'right:0',
                    'bottom:0',
                    'background:rgba(0,0,0,0.92)',
                    'color:#ff6b6b',
                    'font-family:monospace',
                    'font-size:14px',
                    'padding:32px',
                    'z-index:999999',
                    'display:flex',
                    'flex-direction:column',
                    'justify-content:center',
                    'align-items:center',
                    'text-align:center',
                ].join( ';' );
            }
            else
            {
                diagnosticEl.style.cssText = [
                    'position:fixed',
                    'bottom:8px',
                    'right:8px',
                    'max-width:380px',
                    'background:rgba(0,0,0,0.82)',
                    'color:#ff6b6b',
                    'font-family:monospace',
                    'font-size:11px',
                    'line-height:1.4',
                    'padding:6px 10px',
                    'border-radius:4px',
                    'z-index:999999',
                    'pointer-events:none',
                ].join( ';' );
            }

            document.body.appendChild( diagnosticEl );
            injectedElements.push( diagnosticEl );
        }

        var branch  = getConvar( 'ui_branch' )  || 'main';
        var cdnBase = getConvar( 'ui_cdn_base' ) || DEFAULT_CDN_BASE;
        var url     = currentUrl || computeBaseUrl();

        console.log( LOG_PREFIX, 'branch', branch);
        console.log( LOG_PREFIX, 'cdnBase', cdnBase);
        console.log( LOG_PREFIX, 'url', url);
        console.log( LOG_PREFIX, 'errorMsg', errorMsg);

        if ( fullScreen )
        {
            diagnosticEl.innerHTML = [
                '<div style="color:#fff;font-size:18px;margin-bottom:16px">NUI Loader — Failed to load</div>',
                '<div style="color:#aaa;margin-bottom:8px">Resource: <span style="color:#ffd93d">' + resource + '</span></div>',
                '<div style="color:#aaa;margin-bottom:8px">Branch: <span style="color:#ffd93d">' + branch + '</span></div>',
                '<div style="color:#aaa;margin-bottom:8px">CDN: <span style="color:#ffd93d">' + cdnBase + '</span></div>',
                '<div style="color:#aaa;margin-bottom:16px">URL: <span style="color:#ffd93d">' + url + '</span></div>',
                '<div style="color:#ff6b6b;font-size:13px">' + errorMsg + '</div>',
            ].join( '' );
        }
        else
        {
            diagnosticEl.textContent = 'NUI loader (' + resource + '): ' + errorMsg;
        }
    }

    function hideDiagnostic()
    {
        if ( diagnosticEl && diagnosticEl.parentNode )
        {
            diagnosticEl.parentNode.removeChild( diagnosticEl );

            var idx = injectedElements.indexOf( diagnosticEl );

            if ( idx !== -1 )
            {
                injectedElements.splice( idx, 1 );
            }

            diagnosticEl = null;
            setWide({ diagnostic_visible: false });
        }
    }

    // ── Fetch with timeout ──────────────────────────────────────────

    function fetchWithTimeout( url, timeoutMs )
    {
        return new Promise( function ( resolve, reject )
        {
            var timer = setTimeout( function ()
            {
                reject( new Error( 'Timeout after ' + timeoutMs + 'ms' ) );
            }, timeoutMs );

            fetch( url )
                .then( function ( res )
                {
                    clearTimeout( timer );
                    resolve( res );
                })
                .catch( function ( err )
                {
                    clearTimeout( timer );
                    reject( err );
                });
        });
    }

    // ── Main load logic ─────────────────────────────────────────────

    function loadBundle()
    {
        var convarKeys = Object.keys( convars );
        console.log(LOG_PREFIX, '--- Loading bundle --- convars known so far: [' + convarKeys.join( ',' ) + ']');

        if ( convarKeys.length === 0 )
        {
            console.warn(LOG_PREFIX, 'loadBundle() called with NO convars — bundle URL will fall back to defaults');
        }

        clearInjected();
        hideDiagnostic();

        var baseUrl = computeBaseUrl();
        currentUrl  = baseUrl;

        var hostMatch = /^https?:\/\/([^\/]+)/i.exec( baseUrl );
        setWide({
            base_url:     baseUrl,
            cdn_host:     hostMatch ? hostMatch[ 1 ] : '',
            cdn_is_local: isLocalUrl( baseUrl )
        });

        console.log(LOG_PREFIX, 'Base URL:', baseUrl);

        // HMR mode for local development
        if ( isLocalUrl( baseUrl ) )
        {
            console.log(LOG_PREFIX, 'HMR mode (localhost detected)');
            injectHmr( baseUrl );
            return;
        }

        // Try manifest paths in order (Vite 5 first, then Vite 4)
        console.log(LOG_PREFIX, 'Fetching manifest...');
        tryManifestPath( baseUrl, 0 );
    }

    function tryManifestPath( baseUrl, pathIndex )
    {
        if ( pathIndex >= MANIFEST_PATHS.length )
        {
            console.error(LOG_PREFIX, 'All manifest paths exhausted, none found');
            showDiagnostic( 'manifest.json not found at any expected path' );
            return;
        }

        var manifestPath = MANIFEST_PATHS[ pathIndex ];
        var manifestUrl  = baseUrl + '/' + manifestPath;

        var triedSoFar = wide.manifest_paths_tried;
        setWide({ manifest_paths_tried: triedSoFar ? triedSoFar + ',' + manifestPath : manifestPath });

        console.log(LOG_PREFIX, 'Trying manifest:', manifestUrl);

        fetchWithTimeout( manifestUrl, FETCH_TIMEOUT_MS )
            .then( function ( res )
            {
                console.log(LOG_PREFIX, 'Manifest response:', res.status, manifestUrl);
                setWide({ manifest_http_status: res.status });

                if ( !res.ok )
                {
                    console.warn(LOG_PREFIX, 'Manifest not found, trying next path...');
                    tryManifestPath( baseUrl, pathIndex + 1 );
                    return;
                }

                return res.json().then( function ( manifest )
                {
                    var keys = Object.keys( manifest );
                    console.log(LOG_PREFIX, 'Manifest loaded, entries:', keys.length, keys.slice(0, 5));

                    setWide({
                        manifest_path_used: manifestPath,
                        manifest_entries:   keys.length,
                        t_manifest_ok_ms:   nowMs()
                    });

                    hideDiagnostic();
                    injectFromManifest( baseUrl, manifest );
                });
            })
            .catch( function ( err )
            {
                console.error(LOG_PREFIX, 'Fetch error:', err.message || err);

                if ( pathIndex + 1 < MANIFEST_PATHS.length )
                {
                    tryManifestPath( baseUrl, pathIndex + 1 );
                }
                else
                {
                    showDiagnostic( err.message || String( err ) );
                }
            });
    }

    // ── Convar change listener ──────────────────────────────────────

    function isWatchedConvar( name )
    {
        if ( name === 'ui_branch' || name === 'ui_cdn_base' ) return true;

        return name === 'ui_local_' + getUiPageName();
    }

    window.addEventListener( 'message', function ( event )
    {
        var data = event.data;

        console.log(LOG_PREFIX, 'Received message:', JSON.stringify(data, null, 2));

        if ( !data ) return;

        // Any message that isn't from our bootstrap bridge means a game resource
        // is actively trying to open its UI — so a broken loader is now visible
        // to the player and the compact badge should escalate to full-screen.
        var msgType = data.type || data.eventName || '';
        if ( msgType && !BOOTSTRAP_MESSAGE_TYPES[ msgType ] && !uiWasPrompted )
        {
            uiWasPrompted = true;
            setWide({ ui_was_prompted: true, prompted_by_msg_type: msgType });
            console.log(LOG_PREFIX, 'UI prompted by non-bootstrap message type:', msgType);

            if ( diagnosticEl && lastDiagnosticError !== null )
            {
                showDiagnostic( lastDiagnosticError );
            }
        }

        // Lua-side meta dump: arbitrary key/value bag merged into the wide
        // context. Lets the client push player.source, game build, etc. so
        // every subsequent wide event carries them.
        if ( data.type === 'setWide' || data.eventName === 'setWide' )
        {
            var payload = data.data;
            if ( typeof payload === 'string' )
            {
                try { payload = JSON.parse( payload ); } catch ( e ) { payload = null; }
            }
            if ( payload && typeof payload === 'object' )
            {
                setWide( payload );
                console.log(LOG_PREFIX, 'setWide merged:', Object.keys( payload ).join( ',' ));
            }
            return;
        }

        // Lua-side bootstrap signal: callback is now registered, safe to fetch
        if ( data.type === 'bootstrapReady' || data.eventName === 'bootstrapReady' )
        {
            console.log(LOG_PREFIX, 'Received bootstrapReady from Lua → fetching convars now');
            setWide({ bootstrap_ready_received: true, t_bootstrap_ready_ms: nowMs() });

            if ( !initialized && !convarsReady )
            {
                fetchConvars();
            }
            return;
        }

        // Initial convar set on startup
        if ( data.type === 'convarsSet' || data.eventName === 'convarsSet' )
        {
            console.log(LOG_PREFIX, 'Received convarsSet event (initialized=' + initialized + ')');
            if ( data.data && typeof data.data === 'object' )
            {
                convars = data.data;
            }
            else if ( typeof data.data === 'string' )
            {
                try { convars = JSON.parse( data.data ); }
                catch ( e ) { /* ignore */ }
            }

            setWide({
                ui_page_name: getUiPageName(),
                ui_branch:    getConvar( 'ui_branch' ),
                ui_cdn_base:  getConvar( 'ui_cdn_base' )
            });
            emit( 'nui_loader.convars_received', {} );

            if ( !initialized )
            {
                initialized = true;
                loadBundle();
            }

            return;
        }

        // Individual convar change
        if ( data.type === 'convarSet' || data.eventName === 'convarSet' )
        {
            var name  = data.key  || ( data.data && data.data.key )  || '';
            var value = data.value !== undefined ? data.value : ( data.data && data.data.value );

            if ( value === undefined ) value = '';

            convars[ name ] = value;

            if ( isWatchedConvar( name ) )
            {
                // Await the initial convar fetch so we don't reload with a partial payload
                var ready = convarsReady || Promise.resolve();

                ready.then( function ()
                {
                    emit( 'nui_loader.bundle_reloaded', { reason: name, convar_value: String( value ) } );
                    console.log(LOG_PREFIX, 'Watched convar changed:', name, '=', value, '→ reloading');
                    loadBundle();
                });

                return;
            }
        }
    });

    // ── Startup ─────────────────────────────────────────────────────

    // Wait for Lua-side bootstrapReady before fetching, but kick off a fallback fetch
    // shortly after in case the ready message was sent before this script was listening.
    var BOOTSTRAP_READY_FALLBACK_MS = 250;

    console.log(LOG_PREFIX, 'Startup: waiting for bootstrapReady (fallback fetch in ' + BOOTSTRAP_READY_FALLBACK_MS + 'ms)');

    setTimeout( function ()
    {
        if ( !convarsReady )
        {
            console.log(LOG_PREFIX, 'No bootstrapReady yet → starting fallback fetchConvars()');
            fetchConvars();
        }
    }, BOOTSTRAP_READY_FALLBACK_MS );
})();
