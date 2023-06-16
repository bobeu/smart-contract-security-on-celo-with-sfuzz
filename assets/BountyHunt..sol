// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BountyHunt {
  mapping(address => uint) public bountyAmount;
  uint public totalBountyAmount;

  modifier preventTheft {
    _;
    if (address(this).balance < totalBountyAmount) revert();
  }

  function grantBounty(address beneficiary, uint amount) public payable preventTheft {
    bountyAmount[beneficiary] += amount;
    totalBountyAmount += amount;
  }

  function claimBounty() public preventTheft {
    uint balance = bountyAmount[msg.sender];
    (bool sent,) = msg.sender.call{value: balance}("");
    if (sent) {
      totalBountyAmount -= balance;
      bountyAmount[msg.sender] = 0;
    }
  }

  function transferBounty(address to, uint value) public preventTheft {
    if (bountyAmount[msg.sender] >= value) {
      bountyAmount[to] += value;
      bountyAmount[msg.sender] -= value;
    }
  }
}