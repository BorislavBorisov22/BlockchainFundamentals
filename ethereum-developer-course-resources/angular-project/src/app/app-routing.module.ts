import { SendFundsComponent } from './send-funds/send-funds.component';
import { EventsComponent } from './events/events.component';
import { AppComponent } from './app.component';
import { Routes, RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';

const routes: Routes = [
    {path: 'events', pathMatch: 'full', component: EventsComponent},
    {path: 'send-funds', pathMatch: 'full', component: SendFundsComponent},
    {path: '', pathMatch: 'full', redirectTo: 'events' }
];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
})
export class AppRoutingModule {}
