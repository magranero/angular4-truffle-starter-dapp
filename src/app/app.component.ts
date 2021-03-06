import { Component, HostListener, NgZone } from '@angular/core';
const Web3 = require('web3');
const contract = require('truffle-contract');
const metaincoinArtifacts = require('../../build/contracts/MetaCoin.json');
const traceabilityArtifacts = require('../../build/contracts/TraceabilityOfFairTrade.json');
import { canBeNumber } from '../util/validation';

declare var window: any;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent {
  MetaCoin = contract(metaincoinArtifacts);
  Tracking = contract(traceabilityArtifacts);

  // TODO add proper types these variables
  account: any;
  accounts: any;
  web3: any;

  balance: number;
  sendingAmount: number;
  productName: string;
  recipientAddress: string;
  sendingProduct: number;
  state: string;
  status: string;
  canBeNumber = canBeNumber;

  constructor(private _ngZone: NgZone) {

  }

  @HostListener('window:load')
  windowLoaded() {
    this.checkAndInstantiateWeb3();
    this.onReady();
  }

  checkAndInstantiateWeb3 = () => {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof window.web3 !== 'undefined') {
      console.warn(
        'Using web3 detected from external source. If you find that your accounts don\'t appear or you have 0 MetaCoin, ensure you\'ve configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask'
      );
      // Use Mist/MetaMask's provider
      this.web3 = new Web3(window.web3.currentProvider);
    } else {
      console.warn(
        'No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it\'s inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask'
      );
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      this.web3 = new Web3(
        new Web3.providers.HttpProvider('http://localhost:8545')
      );
    }
  };

  onReady = () => {
    // Bootstrap the MetaCoin abstraction for Use.
    this.Tracking.setProvider(this.web3.currentProvider);
    this.MetaCoin.setProvider(this.web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    this.web3.eth.getAccounts((err, accs) => {
      if (err != null) {
        alert('There was an error fetching your accounts.');
        return;
      }

      if (accs.length === 0) {
        alert(
          'Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.'
        );
        return;
      }
      this.accounts = accs;
      this.account = this.accounts[0];

      // This is run from window:load and ZoneJS is not aware of it we
      // need to use _ngZone.run() so that the UI updates on promise resolution
      this._ngZone.run(() =>
        this.refreshBalance()
      );
    });
  };

  refreshBalance = () => {
    let meta;
    this.MetaCoin
      .deployed()
      .then(instance => {
        meta = instance;
        return meta.getBalance.call(this.account, {
          from: this.account
        });
      })
      .then(value => {
        this.balance = value;
      })
      .catch(e => {
        console.log(e);
        this.setStatus('');
      });
      this.Tracking
        .deployed()
        .then(instance => {
          meta = instance;
          return meta.getBalance.call(this.account, {
            from: this.account
          });
        })
        .then(value => {
          this.balance = value;
        })
        .catch(e => {
          console.log(e);
          this.setStatus('');
        });
    };

  setStatus = message => {
    this.status = message;
  };

  sendProduct = () => {
    let track;
    this.Tracking
      .deployed()
      .then(instance => {
        track = instance;
        return track.getProductName(this.sendingProduct, {
          from: this.account
      });
      })
      .then(() => {
        this.setStatus('Transaction complete!');
        this.refreshBalance();
      })
      .catch(e => {
        console.log(e);
        this.setStatus('');
      });
  };

  sendCoin = () => {
    const amount = this.sendingProduct;
    const receiver = this.state;
    let meta;

    this.setStatus('Initiating transaction... (please wait)');

    this.MetaCoin
      .deployed()
      .then(instance => {
        meta = instance;
        return meta.sendCoin(receiver, amount, {
          from: this.account
        });
      })
      .then(() => {
        this.setStatus('Transaction complete!');
        this.refreshBalance();
      })
      .catch(e => {
        console.log(e);
        this.setStatus('Error sending coin; see log.');
      });
  };


  getNumberOfProducts = () => {
    const productName = this.productName;
    let meta;

//    this.getNumberOfProducts('Setting the new product... (please wait)');

    this.Tracking
      .deployed()
      .then(instance => {
        meta = instance;
        return meta.getProduct(productName);
      })
      .then(() => {
        this.setStatus('Product created!');
        this.refreshBalance();
      })
      .catch(e => {
        console.log(e);
        this.setStatus('Error sending coin; see log.');
      });
  };
}
