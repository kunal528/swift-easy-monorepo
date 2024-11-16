import { NextRequest, NextResponse } from "next/server";
import { PrivyClient, WalletApiRpcInputType } from "@privy-io/server-auth";
import { ethers } from "ethers";

const appId: string = process.env.NEXT_PUBLIC_PRIVY_APP_ID || "";
const appSecret: string = process.env.NEXT_PUBLIC_PRIVY_APP_SECRET || "";

const authorizationPrivateKey =
  process.env.NEXT_PUBLIC_PRIVY_WALLET_API_AUTHORIZATION_PRIVATE_KEY || "";

export async function POST(
  req: NextRequest,
  { params }: { params: { method: string } }
) {
  const privy = new PrivyClient(appId, appSecret, {
    walletApi: {
      authorizationPrivateKey: authorizationPrivateKey,
    },
  });

  const { method } = params;

  const { paramSign, phone } = await req.json();

  const contractAddress = "0x8EA46796bD806a053AA76AD9F57CF4E151A0b15A";

  const chainId = 5003;

  const abi = [
    "function initTransfer(uint256,uint256,address) payable",
    "function confirmTransfer(uint256,uint256,address) payable",
  ];

  console.log(paramSign, phone);

  const iface = new ethers.Interface(abi);
  const transactionData = iface.encodeFunctionData(method, paramSign);

  console.log(transactionData);

  try {
    const user = await privy.getUserByPhoneNumber(phone);
    console.log(user);
    const walletAddress = user?.wallet?.address;

    const provider = new ethers.JsonRpcProvider(
      "https://rpc.sepolia.mantle.xyz"
    );

    // get estimated gas
    const estimatedGas = await provider.estimateGas({
      to: contractAddress,
      data: `0x${transactionData.slice(2)}`,
    });

    const feeData = await provider.getFeeData();

    const nonce = await provider.getTransactionCount(walletAddress || "");

    console.log("walletAddress", user?.wallet);

    console.log("estimatedGas", nonce);

    const request: WalletApiRpcInputType = {
      address: walletAddress || "",
      chainType: "ethereum",
      method: "eth_signTransaction",
      params: {
        transaction: {
          to: contractAddress,
          chainId: chainId,
          value: 10 ** 18,
          gasLimit: `0x${ethers.toBeHex(estimatedGas).slice(2)}`,
          maxFeePerGas: feeData.maxFeePerGas
            ? `0x${ethers.toBeHex(feeData.maxFeePerGas).slice(2)}`
            : "0x0",
          maxPriorityFeePerGas: feeData.maxPriorityFeePerGas
            ? `0x${ethers.toBeHex(feeData.maxPriorityFeePerGas).slice(2)}`
            : "0x0",
          data: `0x${transactionData.slice(2)}`,
          nonce: nonce,
          type: 2,
        },
      },
    };

    console.log(request);

    const { data } = await privy.walletApi.rpc(request);

    const signedData = await provider.broadcastTransaction(
      data.signedTransaction
    );
    console.log(signedData);
    // .then((tx) => tx.wait())
    // .catch((err) => {
    //   console.error(err);
    // });

    return NextResponse.json(
      {hash: signedData.hash},
      {
        status: 200,
      }
    );
  } catch (err) {
    console.error(err);
    return NextResponse.json(
      {
        err,
      },
      {
        status: 500,
      }
    );
  }
}