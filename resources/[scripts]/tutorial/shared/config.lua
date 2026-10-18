

config = {
    city = 'cidadenobre',
    startCoords = vec4(404.46, -936.61, -99.00, 175.25),
    objectPosition = vec4(404.75, -946.96, -99.00, 177.79),
    vehicleTaskStartPosition = vec4(-1891.08, -585.14, 11.84, 317.85),
    vehicleSpawnPos = vec4(-1879.74, -579.19, 11.79, 317.94),
    checkPoints = {
        vec4(-1842.61, -595.21, 10.75, 235.28),
        vec4(-1721.23, -704.26, 9.65, 229.61),
        vec4(-1592.32, -812.14, 9.49, 232.45),
        vec4(-1476.58, -883.33, 9.86, 246.62),
        vec4(-1443.41, -951.19, 7.19, 141.74),
        vec4(-1442.5, -969.4, 6.69, 235.28),
        vec4(-1423.55, -963.36, 6.59, 246.62)
    },
    driveToPoint = vec4(-1423.05, -963.55, 7.27, 233.67),
    finishedTutorialCoords = vec4(-1647.37, -1103.89, 12.01, 323.15),
    laser = {
        debugEntityDetectionLine = false, -- if the laser entity detection line should be drawn
        start = vec4(409.23, -955.49, -99.00, 263.88),
        center = vec4(405.29, -955.57, -99.00, 176.44),
        finish = vec4(400.98, -955.59, -99.00, 326.03)
    },
    cameras = {
        [1] = {
            fov = 80.0,
            transitionSpeed = 2000,
            start = vec4(404.91, -944.65, -99.00, 176.08),
            nodes = {
                vec4(404.91, -944.65, -99.00, 176.08),
                vec4(404.46, -936.1, -98.0, 175.25)
            }
        },
        [4] = {
            fov = 100.0,
            transitionSpeed = 4000,
            start = vec4(-1891.08, -585.14, 15.84, 317.85),
            nodes = {
                vec4(-1891.08, -585.14, 15.84, 317.85),
                vec4(-1881.99, -577.43, 15.80, 225.74)
            }
        }
    }
}

config.lang = {
    ['en-us'] = {
        vehicle = {
            title = 'Get in the vehicle',
            description = 'You can press F to enter the vehicle.',
            image = 'car'
        },
        belt = {
            title = 'Seatbelt',
            description = 'You can press G to put on the seatbelt when in the vehicle.',
            image = 'belt'
        },
        drive = {
            title = 'Drive',
            description = 'Go to the destination marked on the map.',
            image = 'point'
        },
        jump = {
            title = 'Jump over the object',
            description = 'Press SPACE when you get close to the wall.',
            image = 'jump'
        },
        crouch = {
            title = 'Go under the laser',
            description = 'Press CTRL when you get close to the blue line.',
            image = 'crounch'
        }
    },
    ['es-es'] = {
        vehicle = {
            title = 'Sube al vehículo',
            description = 'Puedes presionar F para subir al vehículo.',
            image = 'car'
        },
        belt = {
            title = 'Cinturón',
            description = 'Puedes presionar G para ponerte el cinturón cuando estés en el vehículo.',
            image = 'belt'
        },
        drive = {
            title = 'Conduce',
            description = 'Ve hasta el destino marcado en el mapa.',
            image = 'point'
        },
        jump = {
            title = 'Salta sobre el objeto',
            description = 'Presiona ESPACIO cuando llegues cerca del muro.',
            image = 'jump'
        },
        crouch = {
            title = 'Pasa por debajo del láser',
            description = 'Presiona CTRL cuando llegues cerca de la línea azul.',
            image = 'crounch'
        }
    },
    ['pt-pt'] = {
        vehicle = {
            title = 'Entre no veículo',
            description = 'Você pode apertar F para entrar no veículo.',
            image = 'car'
        },
        belt = {
            title = 'Cinto',
            description = 'Você pode apertar G para colocar o cinto quando estiver no veículo.',
            image = 'belt'
        },
        drive = {
            title = 'Dirija',
            description = 'Vá até o destino marcado no mapa.',
            image = 'point'
        },
        jump = {
            title = 'Pule sobre o objeto',
            description = 'Aperte ESPAÇO quando chegar próximo ao muro.',
            image = 'jump'
        },
        crouch = {
            title = 'Passe por baixo do laser',
            description = 'Aperte CTRL quando chegar próximo a linha azul.',
            image = 'crounch'
        }
    },
    ['pt-br'] = {
        vehicle = {
            title = 'Entre no veículo',
            description = 'Você pode apertar F para entrar no veículo.',
            image = 'car'
        },
        belt = {
            title = 'Cinto',
            description = 'Você pode apertar G para colocar o cinto quando estiver no veículo.',
            image = 'belt'
        },
        drive = {
            title = 'Dirija',
            description = 'Vá até o destino marcado no mapa.',
            image = 'point'
        },
        jump = {
            title = 'Pule sobre o objeto',
            description = 'Aperte ESPAÇO quando chegar próximo ao muro.',
            image = 'jump'
        },
        crouch = {
            title = 'Passe por baixo do laser',
            description = 'Aperte CTRL quando chegar próximo a linha azul.',
            image = 'crounch'
        }
    },
}