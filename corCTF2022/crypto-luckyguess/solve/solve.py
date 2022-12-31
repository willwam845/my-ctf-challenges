from pwn import *

s = remote("HOST", PORT)
s.recvuntil("a =")
a = int(s.recvline())
s.recvuntil("b =")
b = int(s.recvline())
p = 2**521 - 1
x = (-b * pow(a-1, -1, p)) % p

s.sendlineafter("point:", str(x))
s.sendlineafter("guess?", str(x))
print(s.recvall())