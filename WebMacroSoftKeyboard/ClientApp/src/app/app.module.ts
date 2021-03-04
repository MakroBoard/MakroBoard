import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatSidenavModule } from '@angular/material/sidenav';
import { FlexLayoutModule } from '@angular/flex-layout';
import { MatCardModule } from '@angular/material/card';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatTabsModule } from '@angular/material/tabs';
import { MatDividerModule } from '@angular/material/divider';
import { MatInputModule } from '@angular/material/input';
import {MatRadioModule} from '@angular/material/radio';


import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './components/login/login.component';
import { HomeComponent } from './components/home/home.component';
import { NavbarComponent } from './components/navbar/navbar.component';
import { ConfigComponent } from './components/config/config.component';
import { IsLocalHostPipe } from './pipes/is-local-host.pipe';
import { ClientComponent } from './components/client/client.component';
import { AuthIntercepter } from './authintercepter';
import { AvailableControlsComponent } from './components/config/available-controls/available-controls.component';
import { PluginComponent } from './components/config/plugin/plugin.component';
import { ControlComponent } from './components/config/control/control.component';
import { ConfigParameterComponent } from './components/config/config-parameter/config-parameter.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { PanelComponent } from './components/pages/panel/panel.component';
import { ButtonComponent } from './components/pages/panel/button/button.component';
import { ConfigValuePipe } from './pipes/config-value.pipe';
import { FilterPipe } from './pipes/filter.pipe';
import { PageComponent } from './components/pages/page/page.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    HomeComponent,
    NavbarComponent,
    ConfigComponent,
    IsLocalHostPipe,
    ClientComponent,
    AvailableControlsComponent,
    PluginComponent,
    ControlComponent,
    ConfigParameterComponent,
    PanelComponent,
    ButtonComponent,
    ConfigValuePipe,
    FilterPipe,
    PageComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    AppRoutingModule,
    NgbModule,
    BrowserAnimationsModule,
    MatToolbarModule,
    MatIconModule,
    MatButtonModule,
    MatTooltipModule,
    MatSidenavModule,
    FlexLayoutModule,
    MatCardModule,
    MatProgressBarModule,
    MatTabsModule,
    MatDividerModule,
    MatInputModule,
    FormsModule,
    MatRadioModule,
    ReactiveFormsModule
  ],
  providers: [IsLocalHostPipe,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthIntercepter,
      multi: true,
    }],
  bootstrap: [AppComponent]
})
export class AppModule { }
