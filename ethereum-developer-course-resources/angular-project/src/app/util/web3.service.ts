import { ContractAbis } from './../constants/contract-abi.constants';
import {Injectable} from '@angular/core';
import Web3 from 'web3';
import {default as contract} from 'truffle-contract';
import {Subject} from 'rxjs/Rx';
import {Contract} from 'web3/types';
declare let window: any;

@Injectable()
export class Web3Service {
  private web3: Web3;
  private accounts: string[];
  public ready = false;
  public SimpleWallet: Contract;
  public accountsObservable = new Subject<string[]>();

  private simpleWalletContract: any;

  constructor() {
      this.bootstrapWeb3();
      this.initializeSimpleWalletContract();
  }

  public async currentAccountBalance(): Promise<Number> {
    const coinbase =  await this.web3.eth.getCoinbase();
    console.log(coinbase, 'coinbase');
    const balance = await this.web3.eth.getBalance(coinbase);
    console.log(balance, 'balance');
    return this.web3.utils.fromWei(balance, 'ether');
  }

  public getAccounts() {
    return this.web3.eth.accounts;
  }

  public bootstrapWeb3() {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof window.web3 !== 'undefined') {
      // Use Mist/MetaMask's provider
      this.web3 = new Web3(window.web3.currentProvider);
    } else {
      console.log('No web3? You should consider trying MetaMask!');

      // Hack to provide backwards compatibility for Truffle, which uses web3js 0.20.x
      Web3.providers.HttpProvider.prototype.sendAsync = Web3.providers.HttpProvider.prototype.send;
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      this.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
    }

    setInterval(() => this.refreshAccounts(), 100);
  }

  public async artifactsToContract(artifacts) {
    if (!this.web3) {
      const delay = new Promise(resolve => setTimeout(resolve, 100));
      await delay;
      return await this.artifactsToContract(artifacts);
    }

    const contractAbstraction = contract(artifacts);
    contractAbstraction.setProvider(this.web3.currentProvider);
    return contractAbstraction;
  }

  private initializeSimpleWalletContract(): void {
    const abi = ContractAbis.SimpleWalletAbi;

    this.simpleWalletContract = new this.web3.eth.Contract(abi);
    this.simpleWalletContract.options.address =
    '0x345ca3e014aaf5dca488057592ee47305d9b3e10';
  }


  public async sendFundsToWallet(etherAmount: Number) {
    const weiToSend = this.web3.utils.toWei(etherAmount, 'ether');
    const coinbase = await this.web3.eth.getCoinbase();

    return this.simpleWalletContract.methods.donate().send({from: coinbase, gasPrice: 3000000, value: weiToSend});
  }

  private testOwnerAndIsAllowed() {
     this.simpleWalletContract.methods
        .getOwner()
        .call({from: this.web3.eth.accounts[0]})
        .then(owner => {
        console.log(owner, 'owner');
      });

      this.simpleWalletContract.methods.isAddressAllowedToSend('0x627306090abaB3A6e1400e9345bC60c78a8BEf57')
        .call({from: this.web3.eth.accounts[0], gasPrice: 3000000})
        .then(isAllowed => {
          console.log(isAllowed, );
        });
  }

  private refreshAccounts() {
    this.web3.eth.getAccounts((err, accs) => {
      // console.log('Refreshing accounts');
      if (err != null) {
        // console.warn('There was an error fetching your accounts.');
        return;
      }

      // Get the initial account balance so it can be displayed.
      if (accs.length === 0) {
        // console.warn('Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.');
        return;
      }

      if (!this.accounts || this.accounts.length !== accs.length || this.accounts[0] !== accs[0]) {
        // console.log('Observed new accounts');

        this.accountsObservable.next(accs);
        this.accounts = accs;
      }

      this.ready = true;
    });
  }
}
