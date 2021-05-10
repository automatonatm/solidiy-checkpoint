
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.17 <0.7.0;

contract Campaign {
    
    struct Request {
        string description;
        uint value;
        address payable recipient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
        
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
   // address[] public approvers;
   mapping(address => bool) public approvers;
   uint public approversCount;
    
    
    
    modifier restricted() {
         require(msg.sender == manager);
        _;
    }
    
     constructor(uint minimum) public {
       manager = msg.sender;
       minimumContribution = minimum;
    }
    
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        //approvers.push(msg.sender);
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    
    function createRequest(string memory description, uint  value, address  payable recipient) public restricted {
        
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
    } 
    
    function approveRequest(uint index) public {
        
        Request storage request = requests[index];
        
        require(approvers[msg.sender]); //check if the contributor exist
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
        
    }
    
    
    function finalizeRequest(uint index) public restricted {
        
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        
        request.recipient.transfer(request.value);
    
        request.complete = true;
        
    }
       
    
    
    
    
  
}
