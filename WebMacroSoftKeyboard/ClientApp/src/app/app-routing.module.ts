import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { PageComponent } from './pages/page/page.component';
import { CheckLocalHostGuardGuard } from './guards/check-local-host-guard.guard';
import { CheckServerTokenGuard } from './guards/check-server-token.guard';
import { HomeComponent } from './pages/home/home.component';
import { ConfigComponent } from './pages/config/config.component';
import { LoginComponent } from './pages/login/login.component';

const routes: Routes = [
  { path: 'home', component: HomeComponent, canActivate: [CheckServerTokenGuard] },
  { path: 'config', component: ConfigComponent, canActivate: [CheckLocalHostGuardGuard] },
  { path: 'login', component: LoginComponent },
  { path: 'page/:name', component: PageComponent },
  { path: '', redirectTo: 'home', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
