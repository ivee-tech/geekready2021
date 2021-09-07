import { AccountInfo } from '@azure/msal-browser';
import Vue from 'vue'
import App from './App.vue'
import './registerServiceWorker'
import router from './router'
import { StoreService } from './services/store-service';
import Home from '@/views/Home.vue';

let account: AccountInfo;
const storeSvc: StoreService = new StoreService();
// let authSvc: AuthService;


Vue.config.productionTip = false
const $path = './assets/config/config.json';
fetch($path).then(response => {
  response.json().then(config => {
    console.log(config);
    storeSvc.setConfig(config);
});
});

new Vue({
  router,
  render: h => h(Home)
}).$mount('#app')
