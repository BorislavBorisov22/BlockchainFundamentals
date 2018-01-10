import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-send-funds',
  templateUrl: './send-funds.component.html',
  styleUrls: ['./send-funds.component.css']
})
export class SendFundsComponent implements OnInit {

  public model: {to: string, amount: number};
  ngOnInit() {
    this.model = {
      to: '',
      amount: 0,
    };
  }

  onSubmit() {
    console.log('submitted');
  }
}
