// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

// import aggregator contract from chainlink
// chainlink is a decentralised oracle network
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

// import safemath contract from chainlink
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract CrowdFund {

    // use safemath for every uint256 in the contract
    using SafeMathChainlink for uint256;
    
    // map address to amount to track the value each address sent
    mapping(address => uint256) public addressToAmount;
    
    // array stores the address of each funder
    address[] public funders;
    
    address public owner;
    
    // constructor called once (on deployment) to set the contract owner
    constructor() public {
        owner = msg.sender;
    }

    // functions using the modifier will run this code first
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    // payable public functon to accept funds
    // min funding amount set to fifty dollars in wei
    // require statement checks if min funding amount is met
    // msg.sender and msg.value are saved to the mapping
    // funder gets added to the funders array
    function fund() public payable {
        uint256 minUSD = 50 * 10 ** 18;
        require(conversion(msg.value) >= minUSD, "the min funding amount is fifty dollars");
        addressToAmount[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    // function calls another contract and returns the interface version
    // address used is provided in the chainlink docs
    function version() public view returns (uint256) {
        AggregatorV3Interface feed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return feed.version();
    }
    
    // function returns the price of one eth in usd (in wei)
    // address used is provided in the chainlink docs
    function price() public view returns (uint256) {
        AggregatorV3Interface feed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = feed.latestRoundData();
        return uint256(answer * 10000000000);
    }
    
    // function returns value of eth in usd (in wei)
    function conversion(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = price();
        uint256 ethToUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethToUsd;
    }
    
    // payable function using a modifier so only the owner can withdraw
    // for loop to reset the mapping and array to zero upon withdrawal
    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmount[funder] = 0;
        }
        funders = new address[](0);
    }
}
