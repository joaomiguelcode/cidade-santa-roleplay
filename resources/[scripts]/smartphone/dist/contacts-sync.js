// Sincroniza somente registros ja persistidos pelo servidor, sem abrir/reiniciar o celular.
export function installContactSync(getStore, host = window) {
  host.addEventListener('message', ({ data }) => {
    if (data?.event !== 'externalContactSaved') return;
    const contact = data.args?.[0];
    if (!contact || !Number.isSafeInteger(Number(contact.id)) || Number(contact.id) <= 0 ||
        typeof contact.phone !== 'string' || typeof contact.name !== 'string') return;

    let attempts = 0;
    const apply = () => {
      const store = getStore();
      // A carga inicial de getSettings nao deve sobrescrever o contato novo.
      if (!store.loaded.value) {
        if (++attempts < 60) host.setTimeout(apply, 500);
        return;
      }
      const existing = store.contacts.value.find(item => String(item.id) === String(contact.id) || item.phone === contact.phone);
      if (existing) Object.assign(existing, contact);
      else store.contacts.value.push(contact);
      store.sortContacts();
      store.pusher.emit('ADD_CONTACT', contact);
    };
    apply();
  });
}
