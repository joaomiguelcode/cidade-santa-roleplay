import { fallbackEnglish } from './fallback-en.js';

export let copy = fallbackEnglish;

export function setMatchPanelCopy(value) {
  copy = value && typeof value === 'object' && value.title && value.errors
    ? value
    : fallbackEnglish;
}
