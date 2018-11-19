pragma solidity ^0.4.20;

contract Lottery{
    
    // public b'coz we want to easily access managers address from our JS app
    address public manager; 
    
    //public b'coz we're okay with others seeing who entered into our lottery
    address[] public players;
    
    function Lottery() {
        manager = msg.sender;
    }
    
        
    //public b'coz we want to allow anyone to enter our lottery
    //payable b'coz this function accepts ether from those entering the lottery and then registers them
    function enter() public payable{
        require(msg.value > 0.001 ether);
        
        players.push(msg.sender);
    }
    
    //private b'coz we don't want to give access to all to execute this contract
    function random() private view returns(uint){
        return uint(keccak256(block.difficulty , now , players));
    }
    
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }
    function pickwinner() public restricted{
        uint winnerindex = random() % players.length;
        players[winnerindex].transfer(this.balance);
        players = new address[](0);
    }
    
    function getplayers() public view returns(address[]){
        return players;
    }
}
