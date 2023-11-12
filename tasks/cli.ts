const { buildPoseidon, newMemEmptyTrie } = require("circomlibjs");
const { poseidon2 } = require("poseidon-lite/poseidon2");
const { Command } = require("commander");
const { config } = require("dotenv");
const { green } = require("@colors/colors");
const { ethers, BaseContract, Wallet, Network } = require("ethers");
const snarkjs = require("snarkjs");
const { IncrementalMerkleTree } = require("@zk-kit/incremental-merkle-tree");

config();

const anvilNetwork = new Network("Anvil", 31337);

const program = new Command();

const Deposit = "DEPOSIT";
const Withdraw = "WITHDRAW";

const DepositHex = ethers.toBigInt(0); //ethers.toUtf8Bytes(Deposit));
const WithdrawHex = ethers.toBigInt(1); //ethers.toUtf8Bytes(Withdraw));

const getWallet = async () => {
  const mnemonic = process.env.MNEMONIC;
  const provider = new ethers.JsonRpcProvider(
    "http://127.0.0.1:8545",
    anvilNetwork
  );
  provider._start();
  if (!provider.ready) await provider._waitUntilReady();

  const wallet = mnemonic
    ? Wallet.fromPhrase(mnemonic, provider)
    : Wallet.createRandom(provider);
  return wallet;
};

program
  .name("sh")
  .description("CLI tool for interacting with ShushSwap")
  .version("1.0.0");

program
  .command("deposit")
  .description("Deposit funds into Privacy Hook contract")
  .requiredOption("-t, --token <address>", "Address of token to deposit")
  .requiredOption(
    "-a, --amount <number>",
    "Amount of token to deposit. Note, not formatted to token's decimals"
  )
  .requiredOption(
    "-n, --nullifier <string>",
    "Secret nullifier to associate with deposit"
  )
  .action(async ({ token, amount, nullifier }) => {
    // console.log(token, amount, nullifier);

    // TODO: Check inputs valid as input to circuit

    const poseidon = await buildPoseidon();

    const startingNonce = 0;
    const newNull = poseidon([
      BigInt(ethers.zeroPadBytes(ethers.toUtf8Bytes(nullifier), 31)),
    ]);
    const depositCommitmentHash = poseidon([
      DepositHex,
      BigInt(token),
      BigInt(startingNonce),
      BigInt(amount),
      poseidon.F.toObject(newNull),
    ]);
    const depositCommitment = ethers.toBeHex(
      poseidon.F.toObject(depositCommitmentHash)
    );

    console.log(depositCommitment);
  });

// TODO: Use execa to run deposit

program
  .command("list:contracts")
  .description("Deposit funds into Privacy Hook contract")
  .action(async () => {
    const {
      transactions,
    } = require("../broadcast/DeployPrivacy.sol/31337/run-latest.json");
    const privacyDeployTx = transactions.find(
      (tx) =>
        tx.transactionType === "CALL" &&
        tx.function === "mineDeploy(address,uint256):(address)"
    );
    const privacyPoolAddress = privacyDeployTx.additionalContracts[0].address;
    const { contractAddress: token0Address } = transactions.find(
      (tx) =>
        tx.transactionType === "CREATE" &&
        tx.contractName === "MockToken" &&
        tx.arguments[0] === "Token A"
    );
    const { contractAddress: token1Address } = transactions.find(
      (tx) =>
        tx.transactionType === "CREATE" &&
        tx.contractName === "MockToken" &&
        tx.arguments[0] === "Token B"
    );

    console.log(`Privacy Pool: ${green(privacyPoolAddress)}`);
    console.log(`Token A: ${green(token0Address)}`);
    console.log(`Token B: ${green(token1Address)}`);
  });

program
  .command("spend")
  .description("Spend funds from Privacy Hook contract")
  .requiredOption("-t, --token <address>", "Address of token to deposit")
  .requiredOption(
    "-a, --amount <number>",
    "Amount of token to spend. Note, not formatted to token's decimals"
  )
  .requiredOption(
    "-n, --nullifier <string>",
    "Secret nullifier to associate with deposit"
  )
  .action(async ({ token, amount, nullifier }) => {
    let token0;
    let privacyHook;
    try {
      const {
        transactions,
      } = require("../broadcast/DeployPrivacy.sol/31337/run-latest.json");
      const {
        abi: privacyHookABI,
      } = require("../out/PrivacyHook.sol/PrivacyHook.json");
      const privacyDeployTx = transactions.find(
        (tx) =>
          tx.transactionType === "CALL" &&
          tx.function === "mineDeploy(address,uint256):(address)"
      );
      const privacyPoolAddress = privacyDeployTx.additionalContracts[0].address;
      const wallet = await getWallet();
      // console.log(wallet);
      privacyHook = new BaseContract(
        privacyPoolAddress,
        privacyHookABI,
        wallet
      );
      token0 = transactions.find(
        (tx) =>
          tx.transactionType === "CREATE" &&
          tx.contractName === "MockToken" &&
          tx.arguments[0] === "Token A" // TODO: Determine whether to use token A or B
      ).contractAddress;
    } catch (e) {
      console.log("No deployments found in local broadcast");
      console.log(e);
      return;
    }

    const treeDepth = 20;
    const zeroValue = BigInt(0);
    const poseidon = await buildPoseidon();
    const startingNonce = 0;
    const depositCommitmentHash = poseidon([
      DepositHex,
      BigInt(token0),
      BigInt(startingNonce),
      BigInt(amount),
      poseidon.F.toObject(
        poseidon([
          ethers.toBigInt(
            ethers.zeroPadBytes(ethers.toUtf8Bytes(nullifier), 31)
          ),
        ])
      ),
    ]);
    const leaf = poseidon.F.toObject(depositCommitmentHash);
    // console.log("deposit leaf", leaf);
    const tree = new IncrementalMerkleTree(poseidon2, treeDepth, zeroValue, 2);
    // tree.insert(leaf);
    console.log("preupdate tree root", ethers.toBigInt(tree.root));
    // tree.insert(leaf);
    tree.insert(leaf);
    console.log(`Insert lead at: ${tree.indexOf(leaf)}`);
    const merkleProof = tree.createProof(tree.indexOf(leaf));
    // console.log(ethers.toBigInt(merkleProof.root));
    // const merkleRoot = await privacyHook.getCurrentRoot(token0);

    const inputs = {
      token: BigInt(token0),
      balance: BigInt(amount),
      spendAmount: BigInt(amount / 2),
      nonce: BigInt(0),
      nullifier: ethers.toBigInt(
        ethers.zeroPadBytes(ethers.toUtf8Bytes(nullifier), 31)
      ),
      depositIndices: BigInt(0),
      depositElements: merkleProof.siblings.map((s) => ethers.toBigInt(s[0])),
      merkleRoot: ethers.toBigInt(merkleProof.root),
      // ethers.toBigInt("0x0ea1e1c5684d69bee46689a220cb75a5328cc7c3c061b7009e6e2d58918e4348"), //merkleProof.root),
    };
    console.log(inputs);

    const { proof, publicSignals } = await snarkjs.plonk.fullProve(
      inputs,
      "circuits/build/spend_js/spend.wasm",
      "circuits/build/circuit_0000.zkey"
    );
    console.log(proof);
    console.log(publicSignals);
    const calldataBlob = await snarkjs.plonk.exportSolidityCallData(
      proof,
      publicSignals
    );
    console.log(calldataBlob);
  });

program.parse();
