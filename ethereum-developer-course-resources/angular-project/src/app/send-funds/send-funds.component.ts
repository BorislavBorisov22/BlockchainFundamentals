import { Web3Service } from './../util/web3.service';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-send-funds',
  templateUrl: './send-funds.component.html',
  styleUrls: ['./send-funds.component.css']
})
export class SendFundsComponent implements OnInit {

  public model: {from: string, to: string, amount: number};
  public addresses: string[];

  constructor(private readonly web3Service: Web3Service) {}

  ngOnInit() {
    this.model = {
      from: '',
      to: '',
      amount: 0,
    };

    this.web3Service.accountsObservable.subscribe(accounts => {
      this.addresses = accounts;
    });
  }

  onSubmit() {
    this.depositFunds();
  }

  depositFunds() {
  }
}
