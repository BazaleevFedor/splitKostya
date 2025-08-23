import { Component, OnInit } from '@angular/core';

const themeLocalStorageKey = 'theme';

const SiteThemes = ['light', 'dark'];

@Component({
    selector: 'app-header',
    imports: [],
    templateUrl: './header.html',
    standalone: true,
    styleUrl: './header.scss'
})
export class Header implements OnInit {
    siteThemeIndex = 0;

    toggleTheme(siteThemeIndex?: number) {
        if (siteThemeIndex !== undefined) {
            this.siteThemeIndex = siteThemeIndex;
        } else {
            this.siteThemeIndex = (this.siteThemeIndex + 1) % SiteThemes.length;
        }

        if (typeof window !== 'undefined') {
            localStorage.setItem(themeLocalStorageKey, this.siteThemeIndex.toString())
        }

        SiteThemes.forEach(item => document.body.classList.remove(item));
        document.body.classList.add(SiteThemes[this.siteThemeIndex]);
    }

    ngOnInit(): void {
        if (typeof window === 'undefined') return;

        const savedTheme = Number(localStorage.getItem(themeLocalStorageKey));

        if (!isNaN(savedTheme)) {
            this.toggleTheme(savedTheme);
        }
    }
}
