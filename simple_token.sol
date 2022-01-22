// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

// import the open zeppelin contract
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// contract inherits from the openzeppelin erc20 contract
contract BasicToken is ERC20 {

    // token name and token abbreviation are hard coded
    // 21 million tokens are minted to the address that deploys the contract
    constructor() ERC20("Basic Token", "BASIC") {
        _mint(msg.sender, 21000000 * (10 ** uint256(decimals())));
    }
}
