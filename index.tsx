import { solG1, solG2 } from "@thehubbleproject/bls/dist/mcl";
import { aggregate, BlsSignerFactory } from "@thehubbleproject/bls/dist/signer";
import { formatBytes32String } from "ethers/lib/utils";

function hexToUint8Array(h: any) {
  return Uint8Array.from(Buffer.from(h.slice(2), "hex"));
}
function uint8ArrayToHex(array: Uint8Array): string {
  return (
    "0x" +
    Array.from(array)
      .map((byte) => byte.toString(16).padStart(2, "0"))
      .join("")
  );
}
// 立即执行的异步函数
(async () => {
  const DOMAIN = hexToUint8Array(
    "0x0000000000000000000000000000000000000000000000000000000000000021"
  );

  const hexString = uint8ArrayToHex(DOMAIN);
  console.log({ domain: hexString });
  const factory = await BlsSignerFactory.new();
  const rawMessages = ["Hello", "World", "Are", "You", "Ok"];
  const signers: any[] = [];
  const messages: string[] = [];
  const pubkeys: solG2[] = [];
  const signatures: solG1[] = [];
  for (const raw of rawMessages) {
    const message = formatBytes32String(raw);
    const signer = factory.getSigner(DOMAIN);
    const signature = signer.sign(message);
    signers.push(signer);
    messages.push(message);
    pubkeys.push(signer.pubkey);
    signatures.push(signature);
  }
  const aggSignature = aggregate(signatures);

  console.log({ sig: aggSignature, pubkeys: pubkeys, message: messages });
  console.log(signers[0].verifyMultiple(aggSignature, pubkeys, messages));
})();
