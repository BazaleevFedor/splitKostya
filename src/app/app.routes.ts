import { Routes } from '@angular/router';

import { HomePage } from './pages/home-page/home-page';
import { TripPage } from './pages/trip-page/trip-page';

export const routes: Routes = [
    { path: '', component: HomePage },
    { path: 'trip', component: TripPage },
    { path: '**', redirectTo: '' }
];
