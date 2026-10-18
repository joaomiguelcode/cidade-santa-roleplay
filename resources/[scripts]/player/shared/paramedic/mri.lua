SandyHospitalMriConfig = {
    bedModel = "i45pt_s_hsp_prop_mri_machine_bed",

    bedOutsideCoords = vector3(1756.484, 3654.363, 34.56277),
    bedInsideCoords = vector3(1755.542, 3653.819, 34.56277),
    bedHeading = 120.0,

    patientInteractCoords = vector3(1757.0, 3654.0, 34.56),
    patientInteractSize = vector3(1.5, 1.5, 2.0),

    operatorInteractCoords = vector3(1756.817, 3650.458, 34.583),
    operatorInteractSize = vector3(1.5, 1.5, 2.0),
    operatorInteractHeading = 39.369,
    operatorDeskModel = "i45pt_s_hsp_prop_deskmri",

    observerRadius = 60.0,

    slideDuration = 3000,
    scanDuration = 10000,

    scanLight = {
        coords = vector3(1754.25, 3653.06, 34.74),
        color = { r = 50, g = 140, b = 255 },
        range = 3.0,
        intensity = 5.0,
        flashHz = 3.0,
    },

    patientAnim = {
        dict = "anim@gangops@morgue@table@",
        name = "body_search",
    },

    patientOffset = vector3(0.0, 0.8, 0.95),
    patientRotation = vector3(0.0, 0.0, 180.0),

    interaction = "auto",

    messages = {
        patientPrompt = "Lie on MRI Bed",
        operatorPrompt = "MRI Controls",
        menuTitle = "MRI Scanner",
        moveInside = "Move Bed Inside",
        moveOutside = "Move Bed Outside",
        startScan = "Start MRI Scan",
        scanInProgress = "Scanning...",
        scanComplete = "MRI Scan Complete",
        bedMoving = "Bed is moving...",
        alreadyInUse = "MRI is currently in use",
        noPatient = "No patient on the bed",
        getUpHint = "Press [BACKSPACE] to get up",
        releasePatient = "Release Patient",
        accessDenied = "You do not have access to operate the MRI",
    },

    canOperate = function(_source)
        return true
    end,

    onScanComplete = function(_patient, _operator)
    end,
}
