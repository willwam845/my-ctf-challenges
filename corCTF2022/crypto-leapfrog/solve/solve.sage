from Crypto.Util.number import *
from Crypto.Random.random import *
from collections import Counter
from math import gcd
from functools import reduce

def advance(s, a, b, p):
    return (s*a + b) % p

def calcjumps(jumps): # finds all possible jumps, by combining all combinations
    c = {}
    for i in range(k):
        for j in range(i, k):
            s = sum(jumps[i:j+1])
            if not c.get(s, 0):
                c[s] = []
            c[s].append((i, j+1))
    valid = []
    for s, se in c.items():
        if len(se) >= 3:
            valid.append((s, se))
    print(Counter([len(se) for _, se in valid]))
    if len(valid) < 2:
        return None
    valid.sort()
    return valid

def egcd(a, b):
    x,y, u,v = 0,1, 1,0
    while a != 0:
        q, r = b//a, b%a
        m, n = x-u*q, y-v*q
        b,a, x,y, u,v = a,r, u,v, m,n
    gcd = b
    return gcd, x, y

def calcpmult(jump): # calculates a multiple of p given 3 or more start and end points with same number of steps between them
    n, se = jump
    se += [se[0]]
    starts = [output[s[0]] for s in se]
    ends = [output[s[1]] for s in se]
    xs = []
    os = []
    for i in range(len(se)-1):
        xs.append(starts[i] - starts[i+1])
        os.append(ends[i] - ends[i+1])

    _gcd = gcd(xs[0], xs[1])
    assert all([not x % _gcd for x in xs])
    
    x1, x2, o1, o2 = xs[0], xs[1], os[0], os[1]
    s1, s2 = x1//abs(x1), x2//abs(x2)
    _gcd, y1, y2 = (egcd(abs(x1), abs(x2)))
    y1 *= s1
    y2 *= s2
    x3 = y1*o1 + y2*o2
    cgcd = x3
    ps = [(cgcd * x//_gcd) - o for x, o in zip(xs, os)]
    return reduce(gcd, ps)
    
k = 12
jumps = [5, 3, 23, 13, 24, 6, 10, 9, 7, 4, 19, 16]
output = [26242498579536691811055981149948736081413123636643477706015419836101346754443, 30320412755241177141099565765265147075632060183801443609889236855980299685595, 65684356693401962957802832810273549345608027337432965824937963429120291339333, 15025547765549333168957368149177848577882555487889680742466312084547650972663, 46764069432060214735440855620792051531943268335710103593983788232446614161424, 71575544531523096893697176151110271985899529970263634996534766185719951232899, 8149547548198503668415702507621754973088994278880874813606458793607866713778, 12081871161483608517505346339140143493132928051760353815508503241747142024697, 65627056932006241674763356339068429188278123434638526706264676467885955099667, 23413741607307309476964696379608864503970503243566103692132654387385869400762, 56014408298982744092873649879675961526790332954773022900206888891912862484806, 77000766146189604405769394813422399327596415228762086351262010618717119973525, 14589246063765426640159853561271509992635998018136452450026806673980229327448]
valid = calcjumps(jumps)
ps = [calcpmult(v) for v in valid]
p = reduce(gcd, ps)

# remove small factors
for i in range(1, 100):
    if not p % i:
        p //= i

assert isPrime(p)

# too lazy to do anything else so i'm just chucking groebner at it
P.<a, b> = PolynomialRing(GF(p))
polys = []
s = output[0]
for i, jump in enumerate(jumps[:3]):
    for _ in range(jump):
        s = s * a + b
    polys.append(s - output[i+1])
I = Ideal(polys).groebner_basis()

roots = []
for poly in list(I):
    roots.append(poly.univariate_polynomial().roots()[0][0])
print(I)
a, b = roots
print(roots)

from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
from hashlib import sha256

key = sha256(b"".join([long_to_bytes(int(x)) for x in [a, b, p]])).digest()[:16]
ct = bytes.fromhex("05ac5b17c67bcfbf5c43fa9d319cfc4c62ee1ce1ab2130846f776e783e5797ac1c02a34045e4130f3b8111e57397df344bd0e14f3df4f1a822c43c7a89fd4113f9a7702b0b0e0b0473a2cbac25e1dd9c")

iv = ct[:16]
cipher = AES.new(key, AES.MODE_CBC, iv=iv)
print("flag:", unpad(cipher.decrypt(ct[16:]), 16).decode())