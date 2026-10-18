(() => {
  'use strict';
  const params = new URLSearchParams(location.search);
  const token = params.get('token');
  const preview = params.has('preview');
  const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'dminigames';
  const base = 'https://santaimagens.roleplayrp.com/img/inventory/';
  const special = {
    burgershot1: 'relogio_ouro', burgershot2: 'colar_perolas', burgershot3: 'brinco_diamante', burgershot4: 'anel_noivado',
    pizzathis1: 'medalhao_familia', pizzathis2: 'alianca_dourada', pizzathis3: 'broche_antigo', pizzathis4: 'moeda_mortuaria',
    uwucoffee1: 'osso_humano', uwucoffee2: 'cranio_velho', uwucoffee3: 'olho_apodrecido', uwucoffee4: 'cerebro_podre',
    beanmachine1: 'mao_esqueletica', beanmachine2: 'dente_amarelado', beanmachine3: 'fragmento_caixao', beanmachine4: 'terra_cova',
  };
  const positions = [[168,184], [288,160], [358,248], [142,296], [246,282], [316,360]];
  const cells = new Map();
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
  let revision = 0;
  let stopped = false;

  async function post(name, data) {
    if (preview || stopped) return {};
    try {
      const response = await fetch(`https://${resource}/${name}`, {
        method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ token, ...data }),
      });
      return await response.json();
    } catch { return {}; }
  }

  function dispose(cell) {
    cell.animations.forEach(animation => animation.cancel());
    cell.animations.clear();
    cell.element.remove();
  }

  function animate(cell, element, frames, options, done) {
    const animation = element.animate(frames, options);
    cell.animations.add(animation);
    animation.onfinish = () => {
      cell.animations.delete(animation);
      animation.cancel();
      if (element.isConnected && done) done();
    };
  }

  function createItem(cell, icon, index, splash) {
    const [x, y] = positions[index];
    const item = document.createElement('div');
    item.className = 'item';
    item.style.left = `${x}px`;
    item.style.top = `${y}px`;
    // Fallback local: nao depende de uma segunda imagem externa que pode falhar.
    item.innerHTML = '<svg class="fallback" viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.7"><path d="m16 3 12 7v13l-12 7-12-7V10Z M4 10l12 7 12-7M16 17v13M10 6l12 7"/></svg>';
    const image = new Image();
    image.alt = '';
    image.draggable = false;
    image.onload = () => { if (item.isConnected) item.classList.add('loaded'); };
    image.onerror = () => image.remove();
    const name = special[icon.image] || icon.image || 'no-image';
    image.src = `${base}${encodeURIComponent(name)}.png`;
    item.append(image);
    cell.element.append(item);
    const floating = () => {
      item.classList.add('floating');
      item.style.animationDelay = `${-index * 0.31}s`;
    };
    if (splash && !reduced) {
      animate(cell, item, [
        { transform: `translate(calc(-50% + ${256-x}px), calc(-50% + ${272-y}px)) scale(.65)`, opacity: .5 },
        { transform: `translate(calc(-50% + ${(256-x)*.25}px), calc(-50% - 24px)) scale(1)`, opacity: 1, offset: .58 },
        { transform: 'translate(-50%, -50%) scale(1)', opacity: 1 },
      ], { duration: 620 + index * 16, easing: 'cubic-bezier(.2,.7,.3,1)' }, floating);
    } else floating();
  }

  function render(data) {
    revision = data.revision;
    const present = new Set();
    for (const pile of data.piles.slice(0, 4)) {
      const slot = pile.slot;
      if (!Number.isInteger(slot) || slot < 1 || slot > 4) continue;
      present.add(slot);
      const signature = JSON.stringify([pile.id, pile.icons]);
      let cell = cells.get(slot);
      if (!cell || cell.signature !== signature) {
        if (cell) dispose(cell);
        const element = document.createElement('div');
        element.className = 'pile';
        element.style.left = `${((slot-1)%2)*512}px`;
        element.style.top = `${Math.floor((slot-1)/2)*512}px`;
        document.body.append(element);
        cell = { element, signature, animations: new Set(), collecting: false };
        cells.set(slot, cell);
        pile.icons.slice(0, 6).forEach((icon, index) => createItem(cell, icon, index, pile.splash));
      }
      if (pile.collecting && !cell.collecting) {
        cell.collecting = true;
        cell.animations.forEach(animation => animation.cancel());
        cell.animations.clear();
        cell.element.querySelectorAll('.item').forEach((item, index) => {
          item.classList.remove('floating');
          const [x, y] = positions[index];
          animate(cell, item, [
            { transform: 'translate(-50%, -50%) scale(1)', opacity: 1 },
            { transform: `translate(calc(-50% + ${256-x}px), calc(-50% + ${256-y}px)) scale(.15)`, opacity: 0 },
          ], { duration: reduced ? 1 : 350, easing: 'ease-in', fill: 'forwards' }, () => { item.style.opacity = '0'; });
        });
      }
    }
    for (const [slot, cell] of cells) {
      if (!present.has(slot)) { dispose(cell); cells.delete(slot); }
    }
    // ACK de layout evita desenhar o UV anterior durante realocacao de celulas.
    const painted = revision;
    requestAnimationFrame(() => requestAnimationFrame(() => {
      if (!stopped && painted === revision) post('dominationLootPainted', { revision: painted });
    }));
  }

  window.addEventListener('message', event => {
    if (event.data?.action === 'piles') render(event.data);
  });
  window.addEventListener('pagehide', () => {
    stopped = true;
    cells.forEach(dispose);
    cells.clear();
  });

  async function ready(attempt = 0) {
    if (stopped || preview) return;
    const result = await post('dominationLootReady', {});
    if (!result.ready && attempt < 60) setTimeout(() => ready(attempt + 1), 250);
  }
  ready();

  if (preview) {
    document.body.style.background = '#30383b';
    const icons = ['m1911', 'pistolammo', 'bandage', 'water', 'radio', 'dollars'].map(image => ({ image }));
    render({ revision: 1, piles: [{ slot: 1, id: 1, icons, splash: true }] });
  }
})();
