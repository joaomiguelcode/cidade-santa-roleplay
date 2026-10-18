// txAdmin in-game monitor server entrypoint
const isServerMode = GetConvar('txAdminServerMode', 'false') === 'true';
console.log('[txAdmin:monitor] Server entrypoint loaded. ServerMode: ' + isServerMode);
