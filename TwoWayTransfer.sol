pragma solidity ^0.4.6;

contract TwoWayTransfer {

  // balances and account list are publicly visible

  mapping(address => uint) public beneficiaryBalance;
  address[2] public beneficiaryList;

  // emit events for real-time listeners and state history

  event LogReceived(address sender, uint amount);
  event LogWithdrawal(address beneficiary, uint amount);
  event LogSent(address beneficiary, uint amount);

  // give the constructor four addresses for the split

  function TwoWayTransfer(address addressA, address addressB) {
    beneficiaryList[0]=addressA;
    beneficiaryList[1]=addressB;
    
  }

  // send ETH

  function pay() 
    public
    payable
    returns(bool success)
  {
   //if(msg.value==0) throw;

    // ignoring values not evenly divisible by 2. We round down and keep the change.
    // TODO: lOSE CHANGE WILL GO BACK TO SENDER

    uint half =msg.value / 2;

    beneficiaryBalance[beneficiaryList[0]] += half;
    beneficiaryBalance[beneficiaryList[1]] += half;
    beneficiaryList[0].send(half);
    beneficiaryList[1].send(half);
    LogSent(beneficiaryList[0], half);
    LogSent(beneficiaryList[1], half);
    LogReceived(msg.sender, msg.value);
    return true;
  }

  

}