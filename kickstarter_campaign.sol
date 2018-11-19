pragma solidity ^0.4.20;

contract CampaignFactory{
    address[] public deployedCampaigns;
    
    function createCampaign(uint min) public {
        
       address newcampaign = new campaign(min , msg.sender);
       deployedCampaigns.push(newcampaign);
       
    }
    
    function getdeployedcampaigns() public view returns(address[]){
        return deployedCampaigns;
    }
}

contract campaign{

    struct Request{
        string description;
        uint value;
        address recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint approval_count;
    }
    
    address public manager;
    uint public mincontribution;
    mapping(address => bool) public approvers;
    uint public approvers_count;
    Request[] public requests;
    
    modifier restrict(){
        require(msg.sender == manager);
        _;
    }
    
    function campaign(uint min , address creator) public {
        manager = creator;    
        mincontribution = min;
    }
    
    function contribute() public payable{
        require(msg.value >= mincontribution);
        
        approvers[msg.sender] = true;
        approvers_count++;
    }
    
    function create_request(string desc , uint val , address rec) 
      public restrict   
      {
        requests.push(Request({
            description: desc,
            value: val,
            recipient: rec,
            complete: false,
            approval_count: 0
        }));
    }
    
    function approve_request(uint req_index) public {
        
        require(approvers[msg.sender] == true);
        require(requests[req_index].approvals[msg.sender] == false);
        
        requests[req_index].approvals[msg.sender] = true;
        requests[req_index].approval_count++;
        
    }
    
    function finalize_request(uint index) public restrict{
        
        require(requests[index].complete == false);
        require(requests[index].approval_count > (approvers_count / 2));
        requests[index].recipient.transfer(requests[index].value);
        requests[index].complete = true;
    }
}
