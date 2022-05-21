/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require('@nomiclabs/hardhat-waffle')
//  require("@nomiclabs/hardhat-web3")
//  require('hardhat-abi-exporter');
 
 const INFURA_API_KEY = "dcb47f8597b9b56d106bec5d6fa71305c8d02248";
 const CHAIN_PRIVATE_KEY = "86e68646347b6c0922410fca78a0d8a1519acf3a99c7983e82e739562ca402ff";
 
 module.exports = {
   solidity: "0.8.1",
   networks: {
     rinkeby: {
       url: `https://rpc-mumbai.maticvigil.com/v1/947e40af287326aec3c6ce0f7ca510bda44b26f5`,
       accounts: [`${CHAIN_PRIVATE_KEY}`]
     }
   },
   abiExporter: {
     path: './data/abi',
     runOnCompile: true,
     clear: true,
     pretty: true,
   }
 };