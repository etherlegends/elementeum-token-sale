pragma solidity ^0.4.18;

import './ElementeumToken.sol';
import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ElementeumTokenProxy is Ownable {

  ElementeumToken public token;

  function ElementeumTokenProxy(uint256 _cap, address[] _founderAccounts, address[] _operationsAccounts) public 
    Ownable() {
    token = new ElementeumToken(_cap, _founderAccounts, _operationsAccounts);
  }

  function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
    return token.mint(_to, _amount);
  }

  function finishMinting() public onlyOwner returns (bool) {
    return token.finishMinting();
  }

  function totalSupply() public returns (uint256) {
    return token.totalSupply();
  }

  function cap() public returns (uint256) {
    return token.cap();
  }
}