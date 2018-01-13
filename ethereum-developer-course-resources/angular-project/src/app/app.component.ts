import { Web3Service } from './util/web3.service';
import {Component, AfterViewInit} from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements AfterViewInit {
  title = 'app works!';
  public currentAccountBalance: Number;

  constructor(private readonly web3Service: Web3Service) {}

  async ngAfterViewInit() {
    this.currentAccountBalance = await this.web3Service.currentAccountBalance();
  }
}
