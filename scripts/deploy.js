const { ethers ,run} = require( "hardhat");
const hre =require('hardhat')
async function main() {

  /* ---TESTNET DEPLOYMENT-- */
  // const Token = await hre.ethers.getContractFactory("TestFamilyTokenV2");
  // //const token = Token.attach('0x8517Bfb7805AFc9Ea1474038f2f606A8463285AC')
  // const token = await Token.deploy();
  // await token.waitForDeployment();
 
  // // console.log(token.target)
  // // await token.deployed();
  // console.log(
  //   `Token deployed to ${token.target}`
  // );  
  await run("verify:verify", {
    contract: "contracts/TestFamilyTokenV2.sol:TestFamilyTokenV2",
    address: "0x953Fc8DBE449457987Cb29E29837690358505Acf",
  });

  /* ---MAINNET DEPLOYMENT-- */
  // const Token = await hre.ethers.getContractFactory("FamilyToken");
  // const token = await Token.deploy();
  // await token.waitForDeployment();
 
  // // console.log(token.target)
  // // await token.deployed();
  // console.log(
  //   `Token deployed to ${token.target}`
  // );  
  // await run("verify:verify", {
  //   contract: "contracts/TestFamilyTokenV2.sol:FamilyToken",
  //   address: token.target,
  // });
  
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});









