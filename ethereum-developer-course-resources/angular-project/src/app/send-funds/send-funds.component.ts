import { Web3Service } from './../util/web3.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-send-funds',
  templateUrl: './send-funds.component.html',
})
export class SendFundsComponent implements OnInit {

  public model: {amount: number};
  public addresses: string[];

  constructor(private readonly web3Service: Web3Service) {}

  ngOnInit() {
    this.model = {
      amount: 0,
    };

    this.web3Service.accountsObservable.subscribe(accounts => {
      this.addresses = accounts;
    });
  }

  async onSubmit() {
    console.log(this.model, 'submitting data');
    await this.depositFunds();
  }

  async depositFunds() {
    await this.web3Service.sendFundsToWallet(this.model.amount);
    alert(`${this.model.amount} funds sent!`);
  }
}
