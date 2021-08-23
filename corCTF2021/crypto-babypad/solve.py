from pwn import *
from Crypto.Util.Padding import unpad
import time

s = remote(sys.argv[1],int(sys.argv[2])) #, level='debug')
ct = bytes.fromhex(s.recvline().decode())
t = time.time()

def bxor(ba1,ba2):
 return bytes([_a ^ _b for _a, _b in zip(ba1, ba2)])

def query(msg):
  s.sendlineafter(b">", msg.hex())
  if int(s.recvline().decode()):
    return 1
  else:
    return 0

def brute(b, iv, p1, p2, block, ct):
  if query(iv + p1[:-1] + bytes([b]) + p2) and ((block+16) < len(ct) or b != ct[-1]):
    return True
  return False

assert query(ct)
assert not query(b'\x00'*32)

flag = b''

for block in range(16, len(ct), 16):
  iv = ct[:block]
  p1 = ct[block:block+16]
  p2 = b""
  i = 1
  for i in range (1, 16):
    b1, b2 = 0, 128
    if p1[-1] >= 128:
      b1, b2 = 128, 256
    for byte in range(b1, b2):
      print(i, byte)
      if brute(byte, iv, p1, p2, block, ct):
        p2 = bytes([byte]) + p2
        p2 = bxor(p2, bytes([i]) * i)
        p2 = bxor(p2, bytes([i+1]) * i)
        p1 = p1[:-1]
        print(i, byte)
        break
    
  for byte in range(256):
    if query(iv + bytes([byte]) + p2):
      p2 = bytes([byte]) + p2
      break
  flag += (bxor(bxor(p2, b'\x10' * 16), ct[block:block+16]))
  print(flag)
  
print(unpad(flag, 16).decode())
print(f"Solved in {time.time() - t} seconds")
