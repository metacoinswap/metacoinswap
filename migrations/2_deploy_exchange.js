const Exchange = artifacts.require("Exchange");
const Custodian = artifacts.require("Custodian");

module.exports = async function(deployer, network, accounts) {
    // deploy a contract
    await deployer.deploy(Exchange, { gas: 30000000, from: accounts[0] });
    //access information about your deployed contract instance
    const ExchangeIns = await Exchange.deployed();
    await deployer.deploy(Custodian, ExchangeIns.address);
}