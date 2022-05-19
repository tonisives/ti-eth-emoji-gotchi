import { Box, Stack } from "@mui/material";
import { Contract, ethers } from "ethers";
import { useEffect, useState } from "react";
import contractAbi from "./contracts/EmojiGotchi.json";

const contractAddr = "0x7621369d0433c8d7baaff647e5551472c0bfacc7";

export type Web3Props = {
  provider: any | undefined;
  signer: any | undefined;
  account: string | undefined;
  chainId: number | undefined;
  contract: Contract | undefined;
};
export var defaultProps: Web3Props = {
  provider: undefined,
  signer: undefined,
  account: "",
  chainId: 0,
  contract: undefined,
};

const useWeb3Props = () => {
  const [contract, setContract] = useState<Contract | undefined>(undefined);

  async function connectWallet() {
    let provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(contractAddr, contractAbi.abi, signer);
    setContract(contract);
  }

  return { contract, connectWallet };
};

function App() {
  const { contract, connectWallet } = useWeb3Props();

  return (
    <Stack alignItems={"center"} spacing={"10px"}>
      <h1>My EmojiGotchi</h1>
      {contract ? (
        <EmojiGotchi contract={contract} />
      ) : (
        <Stack alignItems={"center"} spacing={"10px"}>
          <WalletConnect connectWallet={connectWallet} />
          <Box>
            Add Polygon Mumbai testnet{" "}
            <a href="https://mumbai.polygonscan.com/">here</a>
          </Box>
        </Stack>
      )}
    </Stack>
  );
}

export const WalletConnect = (props: { connectWallet: () => void }) => {
  return (
    <div>
      <button onClick={props.connectWallet}>Connect Wallet</button>
    </div>
  );
};

export const EmojiGotchi = (props: { contract: Contract | undefined }) => {
  const [image, setImage] = useState("");
  const [hunger, setHunger] = useState(0);
  const [enrichment, setEnrichment] = useState(0);
  const [happiness, setHappiness] = useState(0);

  const getMyGotchi = async () => {
    let currentGotchi = await props.contract?.myGotchi();
    setHappiness(await currentGotchi[0].toNumber());
    setHunger(await currentGotchi[1].toNumber());
    setEnrichment(await currentGotchi[2].toNumber());
    setImage(await currentGotchi[4]);

    props.contract?.on("EmojiUpdated", async () => {
      setHappiness(await currentGotchi[0].toNumber());
      setHunger(await currentGotchi[1].toNumber());
      setEnrichment(await currentGotchi[2].toNumber());
      setImage(await currentGotchi[4]);
    });
  };

  useEffect(() => {
    getMyGotchi();
  }, []);

  const play = async () => {
    await props.contract?.play().catch((e: any) => {
      alert(e.message);
    });
  };

  const feed = async () => {
    await props.contract?.feed().catch((e: any) => {
      alert(e.message);
    });
  };

  return (
    <Box width={"300px"}>
      <div>
        <img src={image} alt="Your EmojiGotchi" />
      </div>
      <div>
        Hunger: {hunger}
        <br />
        <Bar percentage={hunger} />
        <button onClick={feed}>Feed</button>
      </div>
      <div>
        Enrichment: {enrichment}
        <br />
        <Bar percentage={enrichment} />
        <button onClick={play}>Play</button>
      </div>
      <div>
        Happiness: {happiness}
        <Bar percentage={happiness} />
        <br />
      </div>
    </Box>
  );
};

export const Bar = (props: { percentage: number }) => {
  return (
    <Box
      sx={{
        height: "8px",
        background: "lightBlue",
      }}
    >
      <Box
        sx={{
          height: "8px",
          background: "orange",
          width: `${props.percentage}%`,
        }}
      ></Box>
    </Box>
  );
};

export default App;
