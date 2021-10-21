// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.0;

import { Address } from './libraries/Address.sol';

import { ICustodian } from './libraries/Interfaces.sol';
import { Owned } from './Owned.sol';
import { AssetTransfers } from './libraries/AssetTransfers.sol';


/**
 * @notice The Custodian contract. Holds custody of all deposited funds for whitelisted Exchange
 * contract with minimal additional logic
 */
contract Custodian is ICustodian, Owned {
  // Events //

  /**
   * @notice Emitted on construction and when Admin upgrades the Exchange contract address
   */
  event ExchangeChanged(address oldExchange, address newExchange);

  address _exchange;

  /**
   * @notice Instantiate a new Custodian
   *
   * @dev Sets `owner` and `admin` to `msg.sender`. Sets initial values for Exchange contract 
   * address, after which it can only be changed by admin account
   *
   * @param exchange Address of deployed Exchange contract to whitelist
   */
  constructor(address exchange) Owned() {
    require(Address.isContract(exchange), 'Invalid exchange contract address');

    _exchange = exchange;

    emit ExchangeChanged(address(0x0), exchange);
  }

  /**
   * @notice BNB can only be sent by the Exchange
   */
  receive() external override payable onlyExchange {}

  /**
   * @notice Withdraw any asset and amount to a target wallet
   *
   * @dev No balance checking performed
   *
   * @param wallet The wallet to which assets will be returned
   * @param asset The address of the asset to withdraw (BNB or BEP20 contract)
   * @param quantityInAssetUnits The quantity in asset units to withdraw
   */
  function withdraw(
    address payable wallet,
    address asset,
    uint256 quantityInAssetUnits
  ) external override onlyExchange {
    AssetTransfers.transferTo(wallet, asset, quantityInAssetUnits);
  }

  /**
   * @notice Load address of the currently whitelisted Exchange contract
   *
   * @return The address of the currently whitelisted Exchange contract
   */
  function loadExchange() external override view returns (address) {
    return _exchange;
  }

  /**
   * @notice Sets a new Exchange contract address
   *
   * @param newExchange The address of the new whitelisted Exchange contract
   */
  function setExchange(address newExchange) external override onlyAdmin {
    require(Address.isContract(newExchange), 'Invalid contract address');

    address oldExchange = _exchange;
    _exchange = newExchange;

    emit ExchangeChanged(oldExchange, newExchange);
  }

  // RBAC //

  modifier onlyExchange() {
    require(msg.sender == _exchange, 'Caller must be Exchange contract');
    _;
  }
}
