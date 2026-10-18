Visibility = {}

function Visibility.setVisible(visible)
    if not visible then
        return sx.client.visibility.addVisibilityOverrideExcludePlayer(sx.client.visibility.beginVisibilityOverride(), PlayerId()) -- Não deixar o player local invisivel!
    end
    return sx.client.visibility.endVisibilityOverride()
end