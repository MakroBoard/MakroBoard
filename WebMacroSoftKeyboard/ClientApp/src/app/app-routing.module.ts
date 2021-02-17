import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ConfigComponent } from './components/config/config.component';
import { HomeComponent } from './components/home/home.component';
import { LoginComponent } from './components/login/login.component';
import { CheckLocalHostGuardGuard } from './guards/check-local-host-guard.guard';
import { CheckServerTokenGuard } from './guards/check-server-token.guard';

const routes: Routes = [
  { path: 'home', component: HomeComponent, canActivate: [CheckServerTokenGuard] },
  { path: 'config', component: ConfigComponent, canActivate: [CheckLocalHostGuardGuard] },
  { path: 'login', component: LoginComponent },
  { path: '', redirectTo: 'home', pathMatch: 'full' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
