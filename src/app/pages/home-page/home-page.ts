import { Component } from '@angular/core';
import { Translate } from '../../services/translate/translate';

@Component({
    selector: 'app-home-page',
    standalone: true,
    imports: [],
    templateUrl: './home-page.html',
    styleUrl: './home-page.scss'
})
export class HomePage {
    constructor(public translate: Translate) {}
}
