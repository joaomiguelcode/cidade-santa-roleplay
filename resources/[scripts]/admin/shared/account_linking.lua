-- Account linking safeguard is disabled in all cities.
while not (sx and sx.logger and sx.featureflag) do
    Wait( 50 )
end

ACCOUNT_LINKING_LOGGER = sx.logger:child({ })

IS_ACCOUNT_LINKING_ENABLED = sx.featureflag({
    key = 'account_linking_safeguard',
    defaultValue = false,
    decide = function()
        return false
    end,
})
