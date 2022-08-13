const hre = require("hardhat");
const abi = require("../artifacts/contracts/chainBattles.sol/ChainBattles.json");

async function main() {
    // Get the contract that has been deployed to Goerli.
    const contractAddress = "0xa75f6277f59b96398eF832148b269C7320E4835F";
    const contractABI = abi.abi;

    // Get the node connection and wallet connection.
    const provider = new hre.ethers.providers.AlchemyProvider("maticmum", process.env.apiKey);

    // Ensure that signer is the SAME address as the original contract deployer,
    // or else this script will fail with an error.
    const signer = new hre.ethers.Wallet(process.env.PRIVATE_KEY, provider);

    // Instantiate connected contract.
    const chainBattles = new hre.ethers.Contract(contractAddress, contractABI, signer);

    console.log("minting NFT..")
    const mint = await chainBattles.mint();
    console.log("NFT minted!");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });