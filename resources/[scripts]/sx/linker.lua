do
    xpcall(
        function()

            if GetConvar( 'language', '' ) ~= 'ar-sa' then
                return
            end

            -- local chunk = LoadResourceFile( 'support-arabic', 'escaping.lua' )

            -- assert( chunk )

            -- local fn, err = load( contents )

            -- assert( fn and not err )

            -- fn()

            -- TODO: Test the performance
            local SupportArabic = exports['support-arabic']

            local addTextEntry = AddTextEntry
                AddTextEntry = function(entryKey, entryText)
                addTextEntry(entryKey, SupportArabic:escape(entryText))
            end

            local addTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
                AddTextComponentSubstringPlayerName = function (text)
                addTextComponentSubstringPlayerName(SupportArabic:escape(text))
            end

            local addTextComponentSubstringKeyboardDisplay = AddTextComponentSubstringKeyboardDisplay
            AddTextComponentSubstringKeyboardDisplay = function (substring)
                addTextComponentSubstringKeyboardDisplay(SupportArabic:escape(substring))
            end

            local addTextComponentSubstringWebsite = AddTextComponentSubstringWebsite
                AddTextComponentSubstringWebsite = function (website)
                addTextComponentSubstringWebsite(SupportArabic:escape(website))
            end

            local getLabelText = GetLabelText
            GetLabelText = function (labelName)
                return SupportArabic:parse(getLabelText(labelName))
            end

            local addTextComponentString = AddTextComponentString
            AddTextComponentString = function( text )
                addTextComponentString(SupportArabic:escape(text))
            end
        end,
        function( err )

            print( err, debug.traceback() )
        end
    )
end


LIB_RESOURCE_NAME = GlobalState['sxlib_resource_name']

assert( LIB_RESOURCE_NAME, ( 'A biblioteca "sx" deve ser iniciada antes do script "%s"'):format( GetCurrentResourceName() ) )

local chunk = LoadResourceFile( LIB_RESOURCE_NAME, 'common/common.lua' )

local fn, err = load( chunk )

assert( fn and not err )

fn()

while not GetIsLibraryFilesystemReady() do
    Wait( 0 )
end

local filesys = GetLibraryFilesystem()

assert( filesys )

for _, path in ipairs( filesys ) do

    local chunk = LoadResourceFile( LIB_RESOURCE_NAME, path )

    if not chunk then
        print( ('^3[SX Linker Warning] Arquivo de biblioteca "%s" não encontrado: %s^0'):format( LIB_RESOURCE_NAME, path ) )
    else
        local fn, err = load( chunk, ('@@%s/%s'):format( LIB_RESOURCE_NAME, path ), nil )

        if not fn or err then
            print( ('^1[SX Linker Error] Error loading library file %s: %s^0'):format( path, err ) )
        else
            local ok, runErr = pcall( fn )
            if not ok then
                print( ('^1[SX Linker Error] Error executing library file %s: %s^0'):format( path, runErr ) )
            end
        end
    end
end