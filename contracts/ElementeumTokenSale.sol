pragma solidity ^0.4.18;

import './ElementeumTokenProxy.sol';
import '../node_modules/zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';


contract ElementeumTokenSale is RefundableCrowdsale {
  using SafeMath for uint256;    

  ElementeumTokenProxy public tokenProxy;

  mapping (address => uint256) public contributions;
  address[] public contributors;
  uint256 public numContributions;
  uint256 public minContribution = 30 finney;
  uint256 public maxContribution = 100 ether;  

  // Exchange rates for each phase of the token sale
  uint256 public quintessenceRate = 2000 wei;  // 1 ETH = 1200 ELET
  uint256 public fireRate         = 1800 wei; // 1 ETH = 1000 ELET 
  uint256 public waterRate        = 1600 wei; // 1 ETH =  900 ELET 
  uint256 public airRate          = 1400 wei; // 1 ETH =  800 ELET 
  uint256 public earthRate        = 1200 wei; // 1 ETH =  700 ELET 

  // Duration of each phase of the token sale
  uint256 public rateQuintessenceEnd = 14 days; // 14 Days
  uint256 public rateFireEnd = 21 days;         //  7 Days
  uint256 public rateWaterEnd = 28 days;        //  7 Days
  uint256 public rateAirEnd = 35 days;          //  7 Days
  uint256 public rateEarthEnd = 42 days;        //  7 Days

  function ElementeumTokenSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, address _wallet, address _tokenProxy)
    Crowdsale(_startTime, _endTime, _rate, _wallet) 
    Ownable() 
    RefundableCrowdsale(_goal) {
    tokenProxy = ElementeumTokenProxy(_tokenProxy);      
    numContributions = 0;
  }

      // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = toELET(weiAmount);

    tokenProxy.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    // update state
    weiRaised = weiRaised.add(weiAmount);
    contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
    contributors.push(beneficiary);
    numContributions++;

    forwardFunds();
  }

    // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    uint256 weiAmount = msg.value;    
    uint256 amountContributed = contributions[msg.sender].add(weiAmount);
    bool withinContributionLimits = amountContributed >= minContribution && amountContributed <= maxContribution;
    bool withinPeriod = now >= startTime && now <= endTime;
    return withinContributionLimits && withinPeriod;
  }

  function toELET(uint256 _wei) public view returns (uint256 amount) {
    uint256 currentRate = rate;
    if (now >= startTime && now <= endTime) {
      if (now <= startTime + rateQuintessenceEnd) {                
        currentRate = quintessenceRate; // Quintessence phase
      } else if (now <= startTime + rateFireEnd) {                
        currentRate = fireRate; // Fire phase
      } else if (now <= startTime + rateWaterEnd) {                
        currentRate = waterRate; // Water phase
      } else if (now <= startTime + rateAirEnd) {
        currentRate = airRate; // Air phase
      } else if (now <= startTime + rateEarthEnd) {
        currentRate = earthRate; // Earth phase
      }
    }
    return _wei.mul(currentRate);
  }

  function finalization() internal {
    uint256 remainingToMint = tokenProxy.cap() - tokenProxy.totalSupply();
    if (remainingToMint > 0) {
      tokenProxy.mint(wallet, remainingToMint);
      tokenProxy.finishMinting();
    }

    super.finalization();
  }

  function getContributors() public onlyOwner returns (address[] ) {
    return contributors;
  }

}