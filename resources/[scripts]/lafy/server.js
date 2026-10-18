// lafy web audio server-side sync
const activeSounds = new Map();

onNet('lafy:play', (id, data) => {
    const src = source;
    activeSounds.set(id, {
        id: id,
        owner: src,
        url: data.url,
        volume: data.volume || 0.5,
        coords: data.coords,
        isVehicle: data.isVehicle || false,
        entityNetId: data.entityNetId || null,
        paused: false,
        timestamp: Date.now()
    });
    emitNet('lafy:play', -1, id, data);
});

onNet('lafy:pause', (id) => {
    if (activeSounds.has(id)) {
        activeSounds.get(id).paused = true;
        emitNet('lafy:pause', -1, id);
    }
});

onNet('lafy:resume', (id) => {
    if (activeSounds.has(id)) {
        activeSounds.get(id).paused = false;
        emitNet('lafy:resume', -1, id);
    }
});

onNet('lafy:stop', (id) => {
    activeSounds.delete(id);
    emitNet('lafy:stop', -1, id);
});

onNet('lafy:volume', (id, volume) => {
    if (activeSounds.has(id)) {
        activeSounds.get(id).volume = volume;
        emitNet('lafy:volume', -1, id, volume);
    }
});

onNet('lafy:position', (id, coords) => {
    if (activeSounds.has(id)) {
        activeSounds.get(id).coords = coords;
        emitNet('lafy:position', -1, id, coords);
    }
});

onNet('lafy:requestSync', () => {
    const src = source;
    for (const [id, sound] of activeSounds.entries()) {
        emitNet('lafy:syncSound', src, sound);
    }
});

on('playerDropped', () => {
    const src = source;
    for (const [id, sound] of activeSounds.entries()) {
        if (sound.owner === src) {
            activeSounds.delete(id);
            emitNet('lafy:stop', -1, id);
        }
    }
});
