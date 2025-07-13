#!/usr/local/bin/python
import os
import json
from Crypto.Cipher import AES

KEY_LENGTH = 16
KEY = open("key.txt", "rb").read()[:KEY_LENGTH]
assert len(KEY) == KEY_LENGTH

FLAG = open("flag.txt", "rb").read().strip()
assert FLAG.startswith(b"dice{") and FLAG.endswith(b"}")
FLAG = FLAG[5:-1]
FLAG = bin(int.from_bytes(FLAG, "big"))[2:].zfill(len(FLAG) * 8)
FLAG = bytes([b"0123"[int(FLAG[i:i+2], 2)] for i in range(0, len(FLAG), 2)])

def xor(a, b):
    return bytes([a_ ^ b_ for a_, b_ in zip(a, b)])

class Cipher:
    def __init__(self, key):
        self.key = key
        self.cipher = AES.new(self.key, AES.MODE_ECB)
        self.block_size = self.cipher.block_size
        self.icv = os.urandom(self.block_size)
        
    def split_blocks(self, plaintext):
        return [plaintext[i:i+self.block_size] for i in range(0, len(plaintext), self.block_size)]
    
    def encrypt_block(self, plaintext):
        assert len(plaintext) % self.block_size == 0
        return self.cipher.encrypt(plaintext)
    
    def encrypt(self, plaintext):
        iv = self.icv
        blocks = self.split_blocks(plaintext)
        n = len(blocks)
        output = iv
        for i in range(n - 1):
            output += self.encrypt_block(xor(output[-self.block_size:], blocks[i]))
        
        d = self.block_size - (len(blocks[-1]) % self.block_size)
        if (d == self.block_size):
            output += self.encrypt_block(xor(output[-self.block_size:], blocks[-1]))
            ocv = self.encrypt_block(output[-self.block_size:])
        else:
            ocv = self.encrypt_block(output[-self.block_size:])
            output = output[:-d] + self.encrypt_block(output[-d:] + blocks[-1])
        
        self.icv = ocv
        return output[self.block_size:]

Cip = Cipher(KEY)

def menu():
    payload = json.loads(input())
    option = payload.get("option", "exit")
    if option == "enc_flag":
        prefix = bytes(min(Cip.block_size, int(payload.get("prefix_length", 0))))
        print(json.dumps({"ct": Cip.encrypt(prefix + FLAG).hex()}))
    elif option == "enc_pt":
        pt = bytes.fromhex(payload.get("plaintext", ""))
        print(json.dumps({"ct": Cip.encrypt(pt).hex()}))
    else:
        print("bye")
        exit()

if __name__ == "__main__":
    print("welcome to nopad!")
    while True: menu()
