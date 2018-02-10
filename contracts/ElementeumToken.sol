pragma solidity ^0.4.18;

import '../node_modules/zeppelin-solidity/contracts/token/CappedToken.sol';

contract ElementeumToken is CappedToken {
  string public constant name = "Elementeum";
  string public constant symbol = "ELET";
  uint8 public constant decimals = 18;

  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
  function ElementeumToken(uint256 _cap, address[] founderAccounts, address[] operationsAccounts) public 
    Ownable()
    CappedToken(_cap)
  {
    // Protect against divide by zero errors
    require(founderAccounts.length > 0);
    require(operationsAccounts.length > 0);

    // 15% Allocated for founders
    uint256 founderAllocation = cap * 15 / 100; 

    // 15% Allocated for operations
    uint256 operationsAllocation = cap * 15 / 100; 

    // Split the founder allocation evenly
    uint256 allocationPerFounder = founderAllocation / founderAccounts.length;

    // Split the operations allocation evenly
    uint256 allocationPerOperationsAccount = operationsAllocation / operationsAccounts.length;

    // Mint the allocation for each of the founders
    for (uint i = 0; i < founderAccounts.length; ++i) {
      mint(founderAccounts[i], allocationPerFounder);
    }

    // Mint the allocation for each of the operations accounts
    for (uint j = 0; j < operationsAccounts.length; ++j) {
      mint(operationsAccounts[j], allocationPerOperationsAccount);
    }
  }
}