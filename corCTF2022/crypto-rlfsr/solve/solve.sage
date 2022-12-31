from tqdm import tqdm

chunksize = 128
knownchunks = 118

bits = 0x824edb4620dca76a4abda968ff8eb44a93c5e55fd3e63f4abec458a6141190f7eb94b0da6712aa1a9d087984402fdd3f57bbbc6cca1156967b4c2bdee51885176dd74c91098f71e2aa339af6f7d9ae081b5f794c4c49bc3085d01c34fdee7e7458d38610c5a2f9879a378b985afe2be32c206b6e33b2bc52ff2f9b1919fe824c56badd1f7122be46f2a2308bf89565a55729d4b83f19707a9db9122680b213fb127f58d030a1337ce76e5c7d31a369f57a68ee92dfe81d239104bb307ff25ced4624feb4f5f917335444ef30338566ce1451ec3b2f41f16ac3295a7decb0131033767a1def651eada3b5b2e69dbd486475d6f4552bf3bc1d1462ccd19f20c3da0139cc165a79968bb33858984f0fba5aa7e39ff6ec4fc466f1ca235b0a989542fed4526ed74bc33ff38562d5e842c1431941d345fcdb2eb1d1cae060b05f2084ddc3bff342b6f4fd13c680a331394a42bf3a8fb3d0ab57dcefa90a5bee60c503fb2cd596889716cbe3d880588c8fc58d4bee0f94daccc176fe1b33ba7aca29876a5005e903abbe6c9d02ce7855db027707ea81e93187624738732a8daf756a3d5d3d62eb105e07b4b35aa64e9c0c99725c5e3ac0ef6ce120d54ad68a61cc6841bc76aef197b0b71e5ca42fab3f047b4a64811611d0cb58e707e04ec10b56ead1adfccece3c7068ff15592a281e71697a756b955dd6147e0494f7a846663964063b3a485ad0ff15290e05c46c51af7ffb87eae257c411e66f7214e88c933770c9d4389e36c9a073d9a3137c2a3dc2dfac8e8ef298a75508ef66debc701b81850ccb774f7cce63dc723cc1b13746277345fa0df4146d183ea444e80d8e3825e29e1db1d59903c038f8cbcf8ed6360ad4806c7cab9f440e3d1d38d1c3577f5c6d6ce1e6dbbbeb89a67a04f004854ced5a17a36c3565ca3d3fdd06c4495cf36c333c1babc47c2eb681bc0c539ac0f1b2eb89a86524ffc4f7f5805872d3b30cba8738ca4db6588e2b72db30502861bcdc519033afa13dd1073db094bcf44fee9bd3488ebb446c3278b8b3f7b350e936a7e9b493c4b1b18655571114f1ab4a9c71871487a70b0648c7622753db39d2d53fb8f4bd4ff278a47428cce871338f149305d921623d7de34348ada43a0bc2137ec9b41d7f465cf3fe57eb6f805df8f85f6c6f7eaff26ad1b20495e41292fb33ea97c0b9b69920371231f08044c491518403f553c593894509060414abe47afcf3ad7617b69a9b423daf39a6d865e4ef5c46e8eaafe752fd79b345b49e77bf75b011e079886949d39db8d7fc5719e37480253dea7c00dd4debdd19c08870a90c3ef2f55109dcead09fc67dfc8fca50c577ec67168da5cdd6053edfbfc0f598137ef9ca1edf36009c6a9f879250ff6a323ee63e81306d834162b63f6fb223bb054f2e8c11611274919ee7d3a3721591ac6d7482142e0d54a4bd8fd07b0ac4a16c6b54792e27143489c2588a6b5cac79b24acd78db75cbe059e4c0ce4cb1d45dafba3c09fbf0aac2b8728d74f558ef538ca4ac9799fa558cc2fbb8beeccf1bf6997f3558a33c267742174b6b1e1431498d3e4884c73e126e904d09625247e1feddfcbe0c9a99258d4e282dc5606f1095f81f96924054e5020abd9dfac52973e3cb7005fb07e3fc67db805797eca46ee9cfcb37129879ec9bcda4a3932eac35988a75e635d8fcd1d2195451fb98edc3d5d0a086405e3484ff8dba16c738ff844583ab65fbc9ade0ccc4d0c310b46fe6fb39815ef3f1bd70f3997ee5290a8d0864133ecb668c13211f9fad682811cb123b76c9fb4cf93f32fbbe7a1300421a8d2710de1027c24a139c6978058d3667a9df2caeaad88da5aaa435331013c8aae10a64fe93d7c138a0f84016c6628fa9e7f62648be24474f2f73b5ee36238cbe0132d6d5a0db57650a8d194bcde065d3cdcf374f21df843675495c2baba1bd22a7f644882982a71804fa7aab4c55300471a4f4c10bd687682b90cea92214110098216348ce4115caa5ef1daa79f36511e4ad594394773eeded215b7a855a03985af9121bc83a0615d07355798f5f63e8f8e615ed5c99868136506e7facf153474a063cb5803fa6d83a713370e92ae2cc68d1304272ff1b407afec261138e8a2107767736cbb74aa28a16ef1b68345eed1e794bd4f0ecbac05dfb0b1307e27be71798f969c6177b981da53e2a172cb553a6f897cd1fdb67b35d6cf3410af88aa3a5040c42a06f3d2414605b9dbc882fefa7f2d76e51592f6cce654e00f9837801fee64a21218bd71c17a9c1cbcfe7e522d8da37886f789457047fe8bd7c8f41365762d8ef2a90e1de426faf18def1c4a2013f46cee4d955afbf9dddd4369ca5544a0c0cdba235359a9aba4a61fae81625c7a4ab7c287a905826af1d184c5eef22ee0940d75937f9ac740dbe7360a6c8c21d140b1dba5d7c5a4bc9449179398d67b83555a40ff1b4cad66dc522d75d6c9c6ae3071fd7c404011c054aa67c6122344f7c73cd9de35c37f2ccd5caa3717f1d5f571192c108dbf15557bb0bef72f830c9b6bd9295d5f1d7bd871d1889b1f849ecf5a8efc13233e38efded7a16772878a685e28944c42529abf0577d8027188658313fc80f65f626074c0d4214a826fad70bd8f39dae2ce8547e7bc29a20f064833267b524aa      
bits = list(map(int, bin(bits)[2:].zfill(knownchunks * chunksize)[::-1]))
chunks = [bits[i:i+chunksize] for i in range(0, len(bits), chunksize)]
chunksums = [sum(chunk)&1 for chunk in chunks]

outs = [1 << (chunksize-1-i) for i in range(chunksize)]
taps = [chunksize-t for t in [1, 2, 7, 3, 12, 73]]
while len(outs) != len(bits):
    states = [outs[-t] for t in taps]
    outs.append(reduce(lambda a, b: a ^^ b, states))
    
outchunks = [outs[i:i+chunksize] for i in range(0, len(outs), chunksize)]
outchunksums = [reduce(lambda a, b: a ^^ b, chunk) for chunk in outchunks]
F = GF(2)

m = []
for chunksum in outchunksums:
    m.append(list(map(int, list("{:0128b}".format(chunksum))))[::-1])

import time
import random
solutions = []
l = chunksize - knownchunks + 2

_v = [[random.randint(0, 2) for _ in range(chunksize)] for _ in range(l)]
_m = m + _v
M = Matrix(F, _m)
# note to self: you can use the kernel for this
for i in tqdm(range(2^l)):
    try:
        v = vector(F, chunksums + list(map(int, list("{:012b}".format(i)))))
        sol = M.solve_right(v)
        sol = ZZ(list(sol), base=2)
        if sol not in solutions:
            solutions.append(sol)
    except Exception as e:
        pass

print(len(solutions))
assert len(solutions) == 2^(l-2)

from hashlib import sha256
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
from Crypto.Util.number import long_to_bytes

ct = bytes.fromhex("38bd5d4c3f5fa5ef8c34cae70a03111d446361d73c4f315f309f6a7ce602b893fdb6d3ae15e2a12668e97c020bf13e54c6e00125e92f9859d8c2ac71a1534a9a234426f4ba3927c797b0924f04aa7f0f79578afc4c3e6054fb3601f88d511934a5424efa4ba2e6e776d91e398afc3c7f5335fefe78c0b58e98ae838f4ae73379")
iv = ct[:16]

for solution in tqdm(solutions):
    aeskey = sha256(long_to_bytes(solution)).digest()[:32]
    c = AES.new(aeskey, AES.MODE_CBC, iv=iv)
    flag = c.decrypt(ct[16:])
    if b"corctf" in flag:
        print(flag)
        break