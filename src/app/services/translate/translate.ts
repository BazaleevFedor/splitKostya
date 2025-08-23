import { Injectable } from '@angular/core';
import { dictionary } from './dictionary';

const languageLocalStorageKey = 'language'
type SiteLanguages = 'ru' | 'en';

@Injectable({
    providedIn: 'root'
})
export class Translate {
    siteLanguage: SiteLanguages = 'ru';

    constructor() {
        if (typeof window !== 'undefined') {
            const savedLanguage = localStorage.getItem(languageLocalStorageKey);

            if (savedLanguage) {
                this.siteLanguage = savedLanguage as SiteLanguages;
            }
        }
    }

    getText(key: string): string | undefined {
        return dictionary.get(key)?.[this.siteLanguage];
    }

    toggleLanguage(siteLanguage: SiteLanguages) {
        this.siteLanguage = siteLanguage;

        if (typeof window !== 'undefined') {
            localStorage.setItem(languageLocalStorageKey, this.siteLanguage)
        }
    }
}
