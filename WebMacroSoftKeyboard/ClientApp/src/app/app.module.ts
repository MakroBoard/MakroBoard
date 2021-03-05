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
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDialogModule } from '@angular/material/dialog';


import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NavbarComponent } from './components/navbar/navbar.component';
import { IsLocalHostPipe } from './pipes/is-local-host.pipe';
import { ClientComponent } from './components/client/client.component';
import { AuthIntercepter } from './authintercepter';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { PanelComponent } from './components/panel/panel.component';
import { ButtonComponent } from './components/panel/button/button.component';
import { ConfigValuePipe } from './pipes/config-value.pipe';
import { FilterPipe } from './pipes/filter.pipe';
import { PageComponent } from './pages/page/page.component';
import { LoginComponent } from './pages/login/login.component';
import { HomeComponent } from './pages/home/home.component';
import { AddPageComponent } from './components/add-page/add-page.component';
import { PluginComponent } from './pages/config/plugin/plugin.component';
import { AvailableControlsComponent } from './pages/config/available-controls/available-controls.component';
import { ConfigComponent } from './pages/config/config.component';
import { ConfigParameterComponent } from './pages/config/config-parameter/config-parameter.component';
import { ControlComponent } from './pages/config/control/control.component';

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
    PageComponent,
    AddPageComponent
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
    MatCheckboxModule,
    ReactiveFormsModule,
    MatDialogModule
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
