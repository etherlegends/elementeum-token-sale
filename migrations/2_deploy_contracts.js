const ElementeumTokenProxy = artifacts.require("./ElementeumTokenProxy.sol")
const ElementeumTokenSale = artifacts.require("./ElementeumTokenSale.sol")

module.exports = function(deployer, network, accounts) {
  const cap = web3.toWei(50000000, "ether", (err, result) => {});
  const startTime = 1518652800; //Feb 15, 2018 at 00:00:00 GMT
  const endTime = startTime + (86400 * 49); // 49 days
  const rate = 1000;  
  const wallet = '0x2Ac9696187a3A56A346c71b2cB6ff90603Aa249e';
  const goal = web3.toWei(250, "ether", (err, result) => {});

  const founderWallet1 = '0xD2344c67c4668220c365B848300c7A7cA8Cd1883';
  const founderWallet2 = '0x66c14Ef6d51c6D095B53363a25c98Cb25F514371';
  const founderWallet3 = '0xf24E600E0a705b9ce8AA6Fa57A12ba171a0AfdfD';
  const gameRewardsWallet = '0xaBD00d1159a0cED97d366c51DDfF91d460c12f11';
  const vendorsAndPartnersWallet = '0xE7D1A2D2502971f5b9cBAE1ED93d10a516Ad885c';
  const bountyAndDevWallet = '0x92F2c7C8bcEEc7E333096d25Db0CE7c827a74205';
  const founders = [founderWallet1, founderWallet2, founderWallet3];
  const operations = [gameRewardsWallet, vendorsAndPartnersWallet, bountyAndDevWallet];

  deployer.deploy(ElementeumTokenProxy, cap, founders, operations).then(function() {
    return deployer.deploy(ElementeumTokenSale, startTime, endTime, rate, goal, wallet, ElementeumTokenProxy.address).then(function() {
      proxy = ElementeumTokenProxy.at(ElementeumTokenProxy.address);
      proxy.transferOwnership(ElementeumTokenSale.address);
    });
  });
};