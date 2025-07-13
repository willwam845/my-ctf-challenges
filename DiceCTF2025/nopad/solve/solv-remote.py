from pwn import *
import os
import random
from tqdm import tqdm
import json

def xor(a, b):
    return bytes([a_ ^ b_ for a_, b_ in zip(a, b)])

flag_alphabet = b"0123"

BLOCK_SIZE = 16

conn1 = remote("dicec.tf", 31002)
conn2 = remote("dicec.tf", 31002)
conn3 = remote("dicec.tf", 31002)

conn1.recvline()
conn2.recvline()
conn3.recvline()

def encrypt_flag3(pref=0):
    conn3.sendline(json.dumps(
        {
            "option": "enc_flag",
            "prefix_length": pref
        }
    ).encode())
    resp = json.loads(conn3.recvline())
    return bytes.fromhex(resp["ct"])

def encrypt_pt3(pt):
    conn3.sendline(json.dumps(
        {
            "option": "enc_pt",
            "plaintext": pt.hex()
        }
    ).encode())
    resp = json.loads(conn3.recvline())
    return bytes.fromhex(resp["ct"])

def encrypt_pt1(pt):
    conn1.sendline(json.dumps(
        {
            "option": "enc_pt",
            "plaintext": pt.hex()
        }
    ).encode())
    resp = json.loads(conn1.recvline())
    return bytes.fromhex(resp["ct"])

def encrypt_pt2(pt):
    conn2.sendline(json.dumps(
        {
            "option": "enc_pt",
            "plaintext": pt.hex()
        }
    ).encode())
    resp = json.loads(conn2.recvline())
    return bytes.fromhex(resp["ct"])

def encrypt_except_first(block): # batchable function!
    query = json.dumps(
        {
            "option": "enc_pt",
            "plaintext": (bytes(BLOCK_SIZE) + block).hex()
        }
    ).encode()
    num_queries = 1000 
    to_send = b"\n".join([query] * num_queries)
    s = set()
    while len(s) != 256:
        conn2.sendline(to_send)
        lines = conn2.recvlines(num_queries)
        lines = [bytes.fromhex(json.loads(line.decode())["ct"])[-BLOCK_SIZE:] for line in lines]
        s = s.union(set(lines))
    return s

def splitb(plaintext):
    return [plaintext[i:i+BLOCK_SIZE] for i in range(0, len(plaintext), BLOCK_SIZE)]

def find_ecb_encryption(block):
    global q
    s = encrypt_except_first(block[1:]) # this function is batchable
    c = 0
    while True:
        c += 1
        if c % 64 == 0: print(c)
        res = encrypt_pt1(bytes(BLOCK_SIZE * 2))
        t = encrypt_pt2(bytes(BLOCK_SIZE) + res[BLOCK_SIZE+1:])[-BLOCK_SIZE:]
        res = encrypt_pt1(xor(block, t))
        if res in s:
            return res

def test_ecb_primitive():
    global q
    trials = 16
    qs = []
    for _ in tqdm(range(trials)):
        q = 0
        pt = os.urandom(BLOCK_SIZE)
        assert ecb_enc(pt) == find_ecb_encryption(pt)
        qs.append(q)
    
    print("primitive works!")
    print("average commands per block:", sum(qs) // trials)

def find_first_block(position):
    global q
    prefix = (-position - 1) % BLOCK_SIZE
    ct = encrypt_pt3(bytes(BLOCK_SIZE))
    iv = find_ecb_encryption(ct)

    flagct = splitb(encrypt_flag3(pref=prefix))
    return iv, flagct[position//BLOCK_SIZE]

def recover_first_block():
    known_flag = b""
    while len(known_flag) != BLOCK_SIZE:
        prefix = (-len(known_flag) - 1) % BLOCK_SIZE
        iv, ct = find_first_block(len(known_flag))
        for possible in flag_alphabet:
            print("bruting", possible)
            pt = xor(iv, bytes(prefix) + known_flag + bytes([possible]))
            if ct in encrypt_except_first(pt[1:]):
                print("sice!!")
                known_flag += bytes([possible])
                break
        print(known_flag)
        print(time.time())

    return known_flag

from Crypto.Util.number import long_to_bytes
def recover_middle_blocks(known):
    found = True
    while found:
        found = False
        known_block = known[-(BLOCK_SIZE-1):]
        prefix_len = (-len(known) - 1) % BLOCK_SIZE
        res = splitb(encrypt_flag3(prefix_len))
        target_block = len(known) // BLOCK_SIZE
        
        for guess in flag_alphabet:
            p2_xor = xor(res[target_block - 1], known_block + bytes([guess]))[1:]
            s = encrypt_except_first(p2_xor)
            if res[target_block] in s:
                print("sice", bytes([guess]))
                known += bytes([guess])
                found = True
        print(long_to_bytes(int(known.decode(), 4)))
        print(known)
    return known

def recover_final_block(known):
    found = True
    
    while found:
        found = False
        known_block = known[-(BLOCK_SIZE-1):]
        prefix_len = (-len(known) - 1) % BLOCK_SIZE
        res = splitb(encrypt_flag3(prefix_len))
        target_block = len(known) // BLOCK_SIZE
        d = BLOCK_SIZE - len(res[-1])
        r = res[target_block][:-d]
        
        for guess in flag_alphabet:
            p2_xor = xor(res[target_block - 1], known_block + bytes([guess]))[1:]
            s = encrypt_except_first(p2_xor)
            s = [x[:len(r)] for x in s]
            if r in s:
                if not found:
                    print("sice", bytes([guess]))
                    to_add = guess
                    found = True
                else:
                    return known
        if found:
            known += bytes([to_add])

        print(long_to_bytes(int(known.decode(), 4)))
        print(known)
    return known

import itertools
def recover_last_byte(final):
    flaglen = len(encrypt_flag3())
    prefix = (-flaglen) % BLOCK_SIZE
    ct = splitb(encrypt_flag3(pref=prefix))
    iv = ct[-2]
    ct = ct[-1]
    to_brute = flaglen - len(final)
    print("need to brute: ", to_brute)
    for flagend in itertools.product(flag_alphabet, repeat=to_brute):
        pt = final[-(BLOCK_SIZE-to_brute):] + bytes(flagend)
        if ct in encrypt_except_first(xor(pt, iv)[1:]):
            print("sice!!!")
            flag = final + bytes(flagend)
            print(flag)
            return long_to_bytes(int(flag.decode(), 4))

t1 = time.time()
print("starting at: ", t1)
block1 = recover_first_block() # if necessary, comment out and set known flag above
t2 = time.time()
print("first block recvored at: ", t2)
print("first block recovered in: ", t2 - t1)
rest = recover_middle_blocks(block1)
t3 = time.time()
print("middle recvored at: ", t3)
print("middle block recovered in: ", t3 - t2)
final = recover_final_block(rest)
t4 = time.time()
print("final recvored at: ", t4)
print("final block recovered in: ", t4 - t3)
flag = recover_last_byte(final)
print("ended last byte recovery at:", time.time())
print("flag recovered in: ", time.time() - t1)

print(f"Flag: dice{{{flag.decode()}}}")
flag = bin(int.from_bytes(flag, "big"))[2:].zfill(len(flag) * 8)
flag = bytes([b"0123"[int(flag[i:i+2], 2)] for i in range(0, len(flag), 2)])
