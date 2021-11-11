// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.0;

import { Address } from './Address.sol';

import { IBEP20, Structs } from './Interfaces.sol';


/**
 * @notice Library helper functions for managing a registry of asset descriptors indexed by address and symbol
 */
library AssetRegistry {
  struct Storage {
    mapping(address => Structs.Asset) assetsByAddress;
    // Mapping value is array since the same symbol can be re-used for a different address
    // (usually as a result of a token swap or upgrade)
    mapping(string => Structs.Asset[]) assetsBySymbol;
  }

  function registerToken(
    Storage storage self,
    IBEP20 tokenAddress,
    string memory symbol,
    uint8 decimals
  ) external {
    require(decimals <= 32, 'More than 32 decimals');
    require(
      tokenAddress != IBEP20(address(0x0)) && Address.isContract(address(tokenAddress)),
      'Invalid address'
    );
    // The string type does not have a length property so cast to bytes to check for empty string
    require(bytes(symbol).length > 0, 'Invalid symbol');
    require(
      !self.assetsByAddress[address(tokenAddress)].isConfirmed,
      'Aready finalized'
    );

    self.assetsByAddress[address(tokenAddress)] = Structs.Asset({
      exists: true,
      assetAddress: address(tokenAddress),
      symbol: symbol,
      decimals: decimals,
      isConfirmed: false,
      confirmedTimestampInMs: 0
    });
  }

  function confirmTokenRegistration(
    Storage storage self,
    IBEP20 tokenAddress,
    string memory symbol,
    uint8 decimals
  ) external {
    Structs.Asset memory asset = self.assetsByAddress[address(tokenAddress)];
    require(asset.exists, 'Unknown token');
    require(!asset.isConfirmed, 'Already finalized');
    require(isStringEqual(asset.symbol, symbol), 'Symbols do not match');
    require(asset.decimals == decimals, 'Decimals do not match');

    asset.isConfirmed = true;
    asset.confirmedTimestampInMs = uint64(block.timestamp * 1000); // Block timestamp is in seconds, store ms
    self.assetsByAddress[address(tokenAddress)] = asset;
    self.assetsBySymbol[symbol].push(asset);
  }

  function addTokenSymbol(
    Storage storage self,
    IBEP20 tokenAddress,
    string memory symbol
  ) external {
    Structs.Asset memory asset = self.assetsByAddress[address(tokenAddress)];
    require(
      asset.exists && asset.isConfirmed,
      'Registration not finalized'
    );
    require(!isStringEqual(symbol, 'BNB'), 'Reserved symbol');

    // This will prevent swapping assets for previously existing orders
    uint64 msInOneSecond = 1000;
    asset.confirmedTimestampInMs = uint64(block.timestamp * msInOneSecond);

    self.assetsBySymbol[symbol].push(asset);
  }

  /**
   * @dev Resolves an asset address into corresponding Asset struct
   *
   * @param assetAddress BNB address of asset
   */
  function loadAssetByAddress(Storage storage self, address assetAddress)
    external
    view
    returns (Structs.Asset memory)
  {
    if (assetAddress == address(0x0)) {
      return getBnbAsset();
    }

    Structs.Asset memory asset = self.assetsByAddress[assetAddress];
    require(
      asset.exists && asset.isConfirmed,
      'No confirmed asset found'
    );

    return asset;
  }

  /**
   * @dev Resolves a asset symbol into corresponding Asset struct
   *
   * @param symbol Asset symbol, e.g. 'IDEX'
   * @param timestampInMs Milliseconds since Unix epoch, usually parsed from a UUID v1 order nonce.
   * Constrains symbol resolution to the asset most recently confirmed prior to timestampInMs. Reverts
   * if no such asset exists
   */
  function loadAssetBySymbol(
    Storage storage self,
    string memory symbol,
    uint64 timestampInMs
  ) external view returns (Structs.Asset memory) {
    if (isStringEqual('BNB', symbol)) {
      return getBnbAsset();
    }

    Structs.Asset memory asset;
    if (self.assetsBySymbol[symbol].length > 0) {
      for (uint8 i = 0; i < self.assetsBySymbol[symbol].length; i++) {
        if (
          self.assetsBySymbol[symbol][i].confirmedTimestampInMs <= timestampInMs
        ) {
          asset = self.assetsBySymbol[symbol][i];
        }
      }
    }
    require(
      asset.exists && asset.isConfirmed,
      'No confirmed asset found'
    );

    return asset;
  }

  /**
   * @dev BNB is modeled as an always-confirmed Asset struct for programmatic consistency
   */
  function getBnbAsset() private pure returns (Structs.Asset memory) {
    return Structs.Asset(true, address(0x0), 'BNB', 18, true, 0);
  }

  // See https://solidity.readthedocs.io/en/latest/types.html#bytes-and-strings-as-arrays
  function isStringEqual(string memory a, string memory b)
    private
    pure
    returns (bool)
  {
    return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
  }
}
