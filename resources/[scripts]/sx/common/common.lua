sx = sx or {}
if not sx.logger then
    local nullLogger = {}
    function nullLogger:debug(...) end
    function nullLogger:info(...) end
    function nullLogger:warn(...) end
    function nullLogger:error(...) end
    function nullLogger:child(...) return self end
    sx.logger = nullLogger
end
RESOURCE_NAME = GetCurrentResourceName()

LIB_RESOURCE_NAME = GlobalState['sxlib_resource_name']

IS_SERVER = GetGameName() == 'fxserver'
IS_CLIENT = not IS_SERVER
IS_SX = RESOURCE_NAME == LIB_RESOURCE_NAME

--- %s is LibraryFileKind
SXLIB_FILE_METADATA_KEY_FMT = 'sxlib_%s_file'

STATEBAG_KEY__SXLIB_SERVER_FILESYSTEM          = 'sxlib_server_filesystem'
STATEBAG_KEY__SXLIB_SERVER_FILESYSTEM_IS_READY = 'sxlib_server_filesystem_is_ready'

STATEBAG_KEY__SXLIB_CLIENT_FILESYSTEM          = 'sxlib_client_filesystem'
STATEBAG_KEY__SXLIB_CLIENT_FILESYSTEM_IS_READY = 'sxlib_client_filesystem_is_ready'

STATEBAG_KEY__SXLIB_FILESYSTEM_IS_READY = IS_SERVER and STATEBAG_KEY__SXLIB_SERVER_FILESYSTEM_IS_READY or STATEBAG_KEY__SXLIB_CLIENT_FILESYSTEM_IS_READY

if IS_CLIENT then

    ---@type Source
    LOCALPLAYER_SOURCE = GetPlayerServerId( PlayerId() )
end

---@param isReady boolean
function GetIsLibraryFilesystemReady( isReady )

    return GlobalState[ STATEBAG_KEY__SXLIB_FILESYSTEM_IS_READY ] == true
end

---@param isReady boolean
function SetIsLibraryFilesystemReady( isReady )

    if IS_CLIENT then

        if isReady then

            while not RequestResourceFileSet( (SXLIB_FILE_METADATA_KEY_FMT):format( 'shared' ) ) do
                Wait( 0 )
            end

            while not RequestResourceFileSet( (SXLIB_FILE_METADATA_KEY_FMT):format( 'client' ) ) do
                Wait( 0 )
            end
        end
    end

    GlobalState:set( STATEBAG_KEY__SXLIB_FILESYSTEM_IS_READY, isReady, false )
end

---@return LibraryFilesystem | nil
function GetLibraryFilesystem()

    if IS_SERVER then
        return exports[ LIB_RESOURCE_NAME ]:getServerLibraryFilesystem()
    end

    -- Client
    return GlobalState[ STATEBAG_KEY__SXLIB_CLIENT_FILESYSTEM ]
end