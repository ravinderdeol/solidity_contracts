// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

contract BasicWallet {

    // variable to store the address of the contract owner
    address owner;
    
    // variables to store the total incoming and outgoing balances
    uint public totalIncoming;
    uint public totalOutgoing;
    
    // function called once (on deployment) to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // function to get the current balance of the wallet
    function currentBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    // function to receive balance into the wallet
    // add the received balance to total incoming
    function receiveBalance() public payable {
        totalIncoming += msg.value;
    }
    
    // function to send balance out of the wallet
    // only the owner of the wallet can send balance
    // add the sent balance to total outgoing
    function sendBalance(address payable _to, uint _amount) public {
        require(owner == msg.sender, "you are not the owner");
        _to.transfer(_amount);
        totalOutgoing += _amount;
    }
}
