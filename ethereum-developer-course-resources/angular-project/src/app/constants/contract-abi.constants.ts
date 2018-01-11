export class ContractAbis {
    public static readonly SimpleWalletAbi = [
    {
      'constant': false,
      'inputs': [
        {
          'name': '_address',
          'type': 'address'
        }
      ],
      'name': 'allowAdressToSendFunds',
      'outputs': [],
      'payable': false,
      'stateMutability': 'nonpayable',
      'type': 'function'
    },
    {
      'constant': true,
      'inputs': [],
      'name': 'getOwner',
      'outputs': [
        {
          'name': '',
          'type': 'address'
        }
      ],
      'payable': false,
      'stateMutability': 'view',
      'type': 'function'
    },
    {
      'constant': true,
      'inputs': [
        {
          'name': '_address',
          'type': 'address'
        }
      ],
      'name': 'isAddressAllowedToSend',
      'outputs': [
        {
          'name': '',
          'type': 'bool'
        }
      ],
      'payable': false,
      'stateMutability': 'view',
      'type': 'function'
    },
    {
      'constant': false,
      'inputs': [
        {
          'name': '_amount',
          'type': 'uint256'
        },
        {
          'name': '_receiver',
          'type': 'address'
        }
      ],
      'name': 'sendFunds',
      'outputs': [
        {
          'name': '',
          'type': 'uint256'
        }
      ],
      'payable': false,
      'stateMutability': 'nonpayable',
      'type': 'function'
    },
    {
      'constant': false,
      'inputs': [],
      'name': 'killWaller',
      'outputs': [],
      'payable': false,
      'stateMutability': 'nonpayable',
      'type': 'function'
    },
    {
      'constant': false,
      'inputs': [
        {
          'name': '_address',
          'type': 'address'
        }
      ],
      'name': 'disallowAdressToSendFunds',
      'outputs': [],
      'payable': false,
      'stateMutability': 'nonpayable',
      'type': 'function'
    },
    {
      'constant': false,
      'inputs': [],
      'name': 'donate',
      'outputs': [],
      'payable': true,
      'stateMutability': 'payable',
      'type': 'function'
    },
    {
      'inputs': [],
      'payable': false,
      'stateMutability': 'nonpayable',
      'type': 'constructor'
    },
    {
      'anonymous': false,
      'inputs': [
        {
          'indexed': false,
          'name': '_sender',
          'type': 'address'
        },
        {
          'indexed': false,
          'name': '_amount',
          'type': 'uint256'
        }
      ],
      'name': 'Deposit',
      'type': 'event'
    },
    {
      'anonymous': false,
      'inputs': [
        {
          'indexed': false,
          'name': '_sender',
          'type': 'address'
        },
        {
          'indexed': false,
          'name': '_amount',
          'type': 'uint256'
        },
        {
          'indexed': false,
          'name': '_beneficiary',
          'type': 'address'
        }
      ],
      'name': 'Withdraw',
      'type': 'event'
    }
  ];
}
