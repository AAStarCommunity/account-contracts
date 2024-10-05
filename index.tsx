import { ethers } from 'ethers';

function base64ToBytes(base64: string): Buffer {
    return Buffer.from(base64, 'base64');
}

function bytesToUint256Array(bytes: Buffer): string[] {
    const uint256Array: string[] = [];
    for (let i = 0; i < bytes.length; i += 32) {
        const chunk = bytes.subarray(i, i + 32);
        uint256Array.push(ethers.toBigInt(chunk).toString());
    }
    return uint256Array;
}

// 立即执行的异步函数
(async () => {

    // 示例数据
    const pubkeyBase64 = 'shxvsYSiVXG/HoCOSO1RFeYzeMBvCxVV/bEPzTk4CH9cZz73ejD5LhrzHIw40UST';
    const msgBase64 = 'YWJj';
    const sigBase64 = 'sKSxcK9kYEpZ0KJbbCbyMSHOjcf6ffauBjVD4TIYYiZaDh69pPugobhxMrj358fRAXt+NdXUkP9HfmqRXPSub8xfVi6alfZ8bGbUvWOK2KN/4S/OLPQaO+BYWZKY2/SF';


    // 解码并转换为 uint256 数组
    const pubkeyBytes = base64ToBytes(pubkeyBase64);
    const msgBytes = base64ToBytes(msgBase64);
    const sigBytes = base64ToBytes(sigBase64);

    const pubkeyUint256Array = bytesToUint256Array(pubkeyBytes);
    const msgUint256Array = bytesToUint256Array(msgBytes);
    const sigUint256Array = bytesToUint256Array(sigBytes);

    console.log('Public Key:', pubkeyUint256Array);
    console.log('Message:', msgUint256Array);
    console.log('Signature:', sigUint256Array);
})();