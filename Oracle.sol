pragma solidity ^0.6.0;

import "./Ownable.sol";

interface Oraclize{
    function oracleCallback(uint256 requsestId,uint256 balance) external returns(bool);
}

contract JointerOracle is Ownable{
    
    uint256 public requsestId;

    mapping(address => bool) public isAllowedAddress;
    mapping(uint256 => bool) public requestFullFilled;
    mapping(uint256 => address) public requestedBy;
    mapping(uint256 => address) public requestedToken;
    mapping(uint256 => address) public requestedUser;
    
    event BalanceRequested(uint256 requsestId,uint256 network,address token,address user);
    event BalanceUpdated(uint256 requsestId,address token,address user,uint256 balance);
    
    // parmeter pass networkId like eth_mainNet = 1,ropsten = 97 etc 
    // token pramter is which token balance you want for native currnecy pass address(0)
    // user which address you want to show
    function getBalance(uint256 network,address token,address user) external returns(uint256){
        require(isAllowedAddress[msg.sender],"ERR_ALLOWED_ADDRESS_ONLY");
        requsestId +=1;
        requestedBy[requsestId] = msg.sender;
        requestedUser[requsestId] = user;
        requestedToken[requsestId] = token;
        emit BalanceRequested(requsestId,network,token,user);
        return requsestId;
    }
    
    
    
    function oracleCallback(uint256 _requsestId,uint256 _balances) external onlyOwner returns(bool){
        require(requestFullFilled[_requsestId]==false,"ERR_REQUESTED_IS_FULLFILLED");
        address _requestedBy = requestedBy[_requsestId];
        Oraclize(_requestedBy).oracleCallback(_requsestId,_balances);
        emit BalanceUpdated(_requsestId,requestedToken[_requsestId],requestedUser[_requsestId],_balances);
        requestFullFilled[_requsestId] = true;
        return true;
    }
    
    function changeAllowedAddress(address _which,bool _bool) external onlyOwner returns(bool){
        isAllowedAddress[_which] = _bool;
        return true;
    }

}
