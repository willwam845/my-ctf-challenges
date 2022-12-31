def mult(s, n):
    y = (pow(a, n, (a-1)*p) - 1) // (a-1) * b
    z = pow(a, n, p) * s
    return (y + z) % p