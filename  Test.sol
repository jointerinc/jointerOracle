pragma solidity ^0.6.0;

interface Oraclize{
    // uint256 ETH_MAINNET = 1;
    // uint256 ETH_ROPSTEN = 3;
    // uint256 BSC_TESTNET = 97;
    // uint256 BSC_MAINNET = 56;
    
    function getBalance(uint256 network,address token,address user) external returns(uint256);
}


contract Test{
    
    address public oraclizeAddress =  address(0);

    struct Requests {
        address user;
        address token;
    }

    mapping(address => mapping(address => uint256)) public _balanceOf;
    
    mapping(uint256 => Requests) requestsData;
    
    
    function getBalance(uint256 network,address token,address user) external returns(bool){
        uint256 requsestId = Oraclize(oraclizeAddress).getBalance(network,token,user);
        Requests memory _request = requestsData[requsestId];
        _request.user = user;
        _request.token = token;
    }
    
    function oracleCallback(uint256 requsestId,uint256 balance) external returns(bool){
        require(msg.sender == oraclizeAddress,"ERR_ONLY_ORCALIAZE");
        Requests memory _request = requestsData[requsestId];
        _balanceOf[_request.user][_request.token] = balance;
        return true;
    }

    
}

