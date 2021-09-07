<template>
  <div id="app">
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';
import { StoreService } from './services/store-service';
import { AuthService } from './auth/auth-service';
import { AccountInfo } from '@azure/msal-browser';  

@Component
export default class HelloWorld extends Vue {
  private storeSvc: StoreService = new StoreService();
  private authSvc: AuthService = new AuthService(this.storeSvc);
  private config; 
  @Prop() private msg!: string;
  @Prop() private user!: AccountInfo; 

  login() {    
    this.authSvc.login("loginPopup", accInfo => {
      this.user = accInfo;
    });    
  }

  logout() {    
    this.authSvc.logout();
  }  
}
</script>

<style>
#app {
  font-family: Script, Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  /* text-align: center; */
  color: #cd4314;
}

#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #cd4314;
}

#nav a.router-link-exact-active {
  color: #ff0000;
}
</style>
