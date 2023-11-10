const { buildPoseidon } = require("circomlibjs");
const { Command } = require("commander");
const { ethers } = require("ethers");

const program = new Command();

const Deposit = "DEPOSIT";
const Withdraw = "WITHDRAW";

const DepositHex = ethers.toBigInt(ethers.toUtf8Bytes(Deposit));
const WithdrawHex = ethers.toBigInt(ethers.toUtf8Bytes(Withdraw));

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
    console.log(token, amount, nullifier);

    // TODO: Check inputs valid as input to circuit

    const poseidon = await buildPoseidon();

    const startingNonce = 0;

    /**
     * depositCommitment = poseidon("DEPOSIT", token, nonce, amount, nullifier)
     * where nonce is incrementing integer starting at 0
     */
    const depositCommitment = ethers.zeroPadBytes(
      poseidon([
        DepositHex,
        token,
        startingNonce,
        amount,
        ethers.toBigInt(ethers.toUtf8Bytes(nullifier)),
      ]),
      32
    );

    console.log(depositCommitment);
  });

program.parse();
