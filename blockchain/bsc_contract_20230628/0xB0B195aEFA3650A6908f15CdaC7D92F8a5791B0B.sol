{{
  "language": "Solidity",
  "sources": {
    "src/proxy/EIP1967Admin.sol": {
      "content": "// SPDX-License-Identifier: CC0-1.0\n\npragma solidity 0.8.15;\n\n/**\n * @title EIP1967Admin\n * @dev Upgradeable proxy pattern implementation according to minimalistic EIP1967.\n */\ncontract EIP1967Admin {\n    // EIP 1967\n    // bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1)\n    uint256 internal constant EIP1967_ADMIN_STORAGE = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;\n\n    modifier onlyAdmin() {\n        require(msg.sender == _admin(), \"EIP1967Admin: not an admin\");\n        _;\n    }\n\n    function _admin() internal view returns (address res) {\n        assembly {\n            res := sload(EIP1967_ADMIN_STORAGE)\n        }\n    }\n}\n"
    },
    "src/proxy/EIP1967Proxy.sol": {
      "content": "// SPDX-License-Identifier: CC0-1.0\n\npragma solidity 0.8.15;\n\nimport \"./EIP1967Admin.sol\";\n\n/**\n * @title EIP1967Proxy\n * @dev Upgradeable proxy pattern implementation according to minimalistic EIP1967.\n */\ncontract EIP1967Proxy is EIP1967Admin {\n    // EIP 1967\n    // bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1)\n    uint256 internal constant EIP1967_IMPLEMENTATION_STORAGE =\n        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;\n\n    event Upgraded(address indexed implementation);\n    event AdminChanged(address previousAdmin, address newAdmin);\n\n    constructor(address _admin, address _implementation, bytes memory _data) payable {\n        _setAdmin(_admin);\n        _setImplementation(_implementation);\n        if (_data.length > 0) {\n            bool status;\n            assembly {\n                status := callcode(gas(), _implementation, callvalue(), add(_data, 32), mload(_data), 0, 0)\n            }\n            require(status, \"EIP1967Proxy: initialize call failed\");\n        }\n    }\n\n    /**\n     * @dev Tells the proxy admin account address.\n     * @return proxy admin address.\n     */\n    function admin() public view returns (address) {\n        return _admin();\n    }\n\n    /**\n     * @dev Tells the proxy implementation contract address.\n     * @return res implementation address.\n     */\n    function implementation() public view returns (address res) {\n        assembly {\n            res := sload(EIP1967_IMPLEMENTATION_STORAGE)\n        }\n    }\n\n    /**\n     * @dev Updates address of the proxy owner.\n     * Callable only by the proxy admin.\n     * @param _admin address of the new proxy admin.\n     */\n    function setAdmin(address _admin) external onlyAdmin {\n        _setAdmin(_admin);\n    }\n\n    /**\n     * @dev Updates proxy implementation address.\n     * Callable only by the proxy admin.\n     * @param _implementation address of the new proxy implementation.\n     */\n    function upgradeTo(address _implementation) external onlyAdmin {\n        _setImplementation(_implementation);\n    }\n\n    /**\n     * @dev Updates proxy implementation address and makes an initialization call to new implementation.\n     * Callable only by the proxy admin.\n     * @param _implementation address of the new proxy implementation.\n     * @param _data calldata to pass through the new implementation after the upgrade.\n     */\n    function upgradeToAndCall(address _implementation, bytes calldata _data) external payable onlyAdmin {\n        _setImplementation(_implementation);\n        (bool status,) = address(this).call{value: msg.value}(_data);\n        require(status, \"EIP1967Proxy: update call failed\");\n    }\n\n    /**\n     * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n     * This function will return whatever the implementation call returns\n     */\n    fallback() external payable {\n        address impl = implementation();\n        require(impl != address(0));\n        assembly {\n            // Copy msg.data. We take full control of memory in this inline assembly\n            // block because it will not return to Solidity code. We overwrite the\n            // Solidity scratch pad at memory position 0.\n            calldatacopy(0, 0, calldatasize())\n\n            // Call the implementation.\n            // out and outsize are 0 because we don't know the size yet.\n            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)\n\n            // Copy the returned data.\n            returndatacopy(0, 0, returndatasize())\n\n            switch result\n            // delegatecall returns 0 on error.\n            case 0 { revert(0, returndatasize()) }\n            default { return(0, returndatasize()) }\n        }\n    }\n\n    /**\n     * @dev Internal function for transfer current admin rights to a different account.\n     * @param _admin address of the new administrator.\n     */\n    function _setAdmin(address _admin) internal {\n        address previousAdmin = admin();\n        require(_admin != address(0));\n        require(previousAdmin != _admin);\n        assembly {\n            sstore(EIP1967_ADMIN_STORAGE, _admin)\n        }\n        emit AdminChanged(previousAdmin, _admin);\n    }\n\n    /**\n     * @dev Internal function for setting a new implementation address.\n     * @param _implementation address of the new implementation contract.\n     */\n    function _setImplementation(address _implementation) internal {\n        require(_implementation != address(0));\n        require(implementation() != _implementation);\n        assembly {\n            sstore(EIP1967_IMPLEMENTATION_STORAGE, _implementation)\n        }\n        emit Upgraded(_implementation);\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "@gnosis/=lib/@gnosis/",
      "@gnosis/auction/=lib/@gnosis/auction/contracts/",
      "@openzeppelin/=lib/@openzeppelin/contracts/",
      "@openzeppelin/contracts/=lib/@openzeppelin/contracts/contracts/",
      "@uniswap/=lib/@uniswap/",
      "ds-test/=lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/forge-std/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "bytecodeHash": "ipfs"
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    },
    "evmVersion": "london",
    "libraries": {}
  }
}}