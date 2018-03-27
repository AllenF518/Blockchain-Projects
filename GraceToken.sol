pragma solidity ^0.4.18;

contract GraceToken{
    string message; //a variable that stores the message 
    uint minPercentIncrease; //how many percent must the new bid exceed the old..
    address owner;//a variable to remember who owns the contract 
    uint oldBalance = 0;
    //events are a way for the user interface to listen for the results of smart contract transactions
    event MessageChanged(address sender, uint price, string mesg);
    event ChangeFailed(address sender, uint price);
    
     mapping(address => uint) public beneficiaryBalance;
  address[1] public beneficiaryList;

  

  event LogReceived(address sender, uint amount);
  event LogWithdrawal(address beneficiary, uint amount);
  event LogSent(address beneficiary, uint amount);
  event CoinTransfer(address sender, address receiver, uint amount);
    
    function GraceToken (string data, uint minPct,address toAddress) public payable { //public means anybody can use it
        message = data; // store the provided data as the message
        //msg.sender is a special variable that has the address of the account that called this function
        //msg.sender is automatically set by the solidity contract framework when just before begins
        owner = msg.sender;
        minPercentIncrease = minPct;
        oldBalance = this.balance;//this.balance is a special variable holding the balance (wei) of the contract 
        beneficiaryList[0]=toAddress;
        
    }
   
    function getMessage() constant public returns (string)
    {
        return message;
    }
    
    function getMinPrice() public constant returns (uint){
        return (uint) ( (minPercentIncrease/100.0 + 1.0) * oldBalance );
        //notice we can do floating point math, just not store floating point variables (or return values)
    }
    //returns true if change is scucessful
    function setNewMessage(string newMsg) public payable
    {
        //msg.value is a special variable that holds the number of wei sent with the transaction (gas is counted separately)
        if(msg.value > getMinPrice()){
            message = newMsg;
            oldBalance = this.balance;
            MessageChanged(msg.sender, msg.value,  message);

        }else{
            ChangeFailed(msg.sender, msg.value);
        }
    }
    
    //the way this is coded, should only be called by the owner, no need for UI
    function withdraw() public payable{
        if (msg.sender != owner) throw;// punish abusive caller by burning their gas down
        owner.send(this.balance);
    }
    
    function pay() 
    public
    payable
    returns(bool success)
  {
  
    beneficiaryBalance[beneficiaryList[0]] += msg.value;
  
    //beneficiaryList[0].send(half);
    beneficiaryList[0].send(msg.value);
    CoinTransfer(msg.sender, beneficiaryList[0], msg.value);
    LogSent(beneficiaryList[0], msg.value);
    //LogSent(msg.receive, half);
    LogReceived(msg.sender, msg.value);
    return true;
  }
    
}