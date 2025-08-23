import { Injectable, OnInit } from '@angular/core';
import { dictionary } from './dictionary';

const languageLocalStorageKey = 'language'
type SiteLanguages = 'ru' | 'en';

@Injectable({
    providedIn: 'root'
})
export class Translate implements OnInit {
    siteLanguage: SiteLanguages = 'ru';

    getText(key: string): string | undefined {
        return dictionary.get(key)?.[this.siteLanguage];
    }

    toggleLanguage(siteLanguage: SiteLanguages) {
        this.siteLanguage = siteLanguage;

        if (typeof window !== 'undefined') {
            localStorage.setItem(languageLocalStorageKey, this.siteLanguage)
        }
    }

    ngOnInit(): void {
        if (typeof window === 'undefined') return;

        const savedLanguage = localStorage.getItem(languageLocalStorageKey);

        if (savedLanguage) {
            this.toggleLanguage(savedLanguage as SiteLanguages);
        }
    }
}
