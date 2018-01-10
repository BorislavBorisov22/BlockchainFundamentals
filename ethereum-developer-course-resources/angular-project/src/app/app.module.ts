import { RouterModule } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';
import { UtilModule } from './util/util.module';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';
import { SendFundsComponent } from './send-funds/send-funds.component';
import { EventsComponent } from './events/events.component';

@NgModule({
  declarations: [
    AppComponent,
    SendFundsComponent,
    EventsComponent
  ],
  imports: [
    RouterModule,
    AppRoutingModule,
    UtilModule,
    BrowserModule,
    FormsModule,
    HttpModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
