# (a2)y'' + (a1)y' + (a0)y = 0 y' = 5/6 , y(0) = 1
import numpy as np
import matplotlib.pyplot as plt

a2 = lambda x: 1
a1 = lambda x: -2
a0 = lambda x: 1

delta_x = 0.01
n = 400
x_0, y_0, yp_0 = 0, 1, 5/6

def func(x, y, yp_prev):
    return delta_x/(a2(x) + a1(x)*delta_x) * (-a0(x)*y + a2(x) / delta_x * yp_prev)

f = np.zeros((n, 3))
f[0] = [x_0, y_0, yp_0]

for i in range(1, n):
    x, y, yp = f[i-1]
    v = func(x, y, yp)
    f[i] = [x + delta_x, y + delta_x * v, v]


g = np.zeros((n, 3))
f[0] = [x_0, y_0, yp_0]
for i in range(1, n):
    x, y, yp = f[i-1]
    k1 = func(x, y, yp)
    k2 = func(x + delta_x/2, y + k1*delta_x/2, yp)
    k3 = func(x + delta_x/2, y + k2*delta_x/2, yp)
    k4 = func(x + delta_x, y + k3*delta_x, yp)
    v = (k1 + 2 * k2 + 2 * k3 + k4) / 6
    yn = y + delta_x * v
    g[i] = [x + delta_x, yn, v]

plt.plot(g[:, 0], g[:, 1], label='Eul')
plt.plot(f[:, 0], f[:, 1], label='approx')
plt.legend()
plt.show()
