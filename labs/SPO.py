import matplotlib.pyplot as plt
import matplotlib.animation as animation
import psutil
# import platform
# import socket
# import os

# def get_system_info():
#     return {
#         "Операционная система": platform.system() + " " + platform.release(),
#         "Имя компьютера": socket.gethostname(),
#         "Имя пользователя": os.getlogin(),
#         "Архитектура": platform.architecture()[0],
#         "Процессор": platform.processor(),
#         "Логические ядра": psutil.cpu_count(logical=True),
#         "Физические ядра": psutil.cpu_count(logical=False)
#     }
#
# cpu_usage = []
# memory_usage = []
# disk_usage = []
# maxim_point = 50
#
# graph, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(8, 10))
# graph.subplots_adjust(hspace=0.5)
#
# def update_data(frame):
#     cpu_usage.append(psutil.cpu_percent())
#     memory_usage.append(psutil.virtual_memory().percent)
#     disk_usage.append(psutil.disk_usage("/").percent)
#
#     if len(cpu_usage) > maxim_point:
#         cpu_usage.pop(0)
#         memory_usage.pop(0)
#         disk_usage.pop(0)
#
#     ax1.clear()
#     ax2.clear()
#     ax3.clear()
#
#     ax1.plot(cpu_usage, label="CPU Usage (%)", color="r")
#     ax2.plot(memory_usage, label="Memory Usage (%)", color="g")
#     ax3.plot(disk_usage, label="Disk Usage (%)", color="b")
#
#     ax1.set_title("CPU Usage")
#     ax2.set_title("Memory Usage")
#     ax3.set_title("Disk Usage")
#
#     for ax in [ax1, ax2, ax3]:
#         ax.set_ylim(0, 100)
#         ax.legend()
#         ax.grid(True)
#
# anim = animation.FuncAnimation(graph, update_data, interval=1000, cache_frame_data=False)
#
# plt.show()
# system_inf = get_system_info()
# information = "\n".join([f"{key}: {value}" for key, value in system_inf.items()])
# print(information)

import numpy as np
fig, ax = plt.subplots(figsize=(8, 10))
plt.title("Ядра(%)")
plt.ylim(0, 50)
plt.grid(True)

num_cores = psutil.cpu_count(logical=True)
x_data = np.arange(30)
y_data = np.zeros((num_cores, 30))

lines = []
for i in range(num_cores):
    line, = ax.plot(x_data, y_data[i], label=f"Ядро {i + 1}")
    lines.append(line)

plt.legend(loc="upper right")

def update(frame):
    cpu_percent = psutil.cpu_percent(interval=1, percpu=True)

    for i in range(num_cores):
        y_data[i] = np.roll(y_data[i], -1)
        y_data[i][-1] = cpu_percent[i]
        lines[i].set_ydata(y_data[i])

    return lines

anim = animation.FuncAnimation(fig,update,interval=1000,cache_frame_data=False )
plt.tight_layout()
plt.show()
