#!/usr/bin/env python
# -*- coding: utf-8 -*-

import socket
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from itertools import count


#####
ClientSocket = socket.socket()
host = '127.0.0.1'
port = 8888

print('Waiting for connection')
try:
    ClientSocket.connect((host, port))
except socket.error as e:
    print(str(e))

#From C code "Echo demon" message  was coming. which it could not convert string into float.
# therefore we declared before to remove the message.

plt.style.use('seaborn')

client_send = ('{Client}: requesting: ')
ClientSocket.send(str.encode(client_send))
Response = ClientSocket.recv(1024)

# Setting lists
Roll = []
Yaw = []
Pitch = []
Acc_x = []
Acc_y = []
Acc_z = []

CPU_ticks_l = []

# Setting Empty plot fig figure with axes
# fig1, ax1 = plt.subplots()
# fig2, ax2 = plt.subplots()

fig = plt.figure()
ax1 = fig.add_subplot(211) #2 rows, 1 coloumn and first in that plot
ax2 = fig.add_subplot(212) #2 rows, 1 coloumn and sencond in that plot

# # Formatting plot
# ax1.set_title('Gyro')
# ax1.set_ylabel('Roll, Yaw, Pitch (rad/sec)')
# ax1.set_xlabel('CPU_Time (ms)')
#
# ax2.set_title('Acceleration')
# ax2.set_ylabel('Acceleration (m/sec^2)')
# ax2.set_xlabel('CPU_Time (ms)')

index = count()


def animate(i, roll, pitch, yaw, acc_x, acc_y, acc_z, cpu_ticks_l):

    client_send = ('{Client}: requesting: ')
    ClientSocket.send(str.encode(client_send))
    Response = ClientSocket.recv(1024)
    print(Response.decode('utf-8'))
    meas = Response.decode('utf-8')
    meas = meas.split(':')

# Add x and y to lists
    roll.append(round(float(meas[0]), 0))
    pitch.append(round(float(meas[1]), 0))
    yaw.append(round(float(meas[2]), 0))

    acc_x.append(round(float(meas[3]), 0))
    acc_y.append(round(float(meas[4]), 0))
    acc_z.append(round(float(meas[5]), 0))

    cpu_ticks_l.append(float(next(index)))


# Limit the lists to 5 items
    roll = roll[-5:]  # a window of 5 elements and its the window keeps moving
    pitch = pitch[-5:]
    yaw = yaw[-5:]
    cpu_ticks_l = cpu_ticks_l[-5:]
    acc_x = acc_x[-5:]
    acc_y = acc_y[-5:]
    acc_z = acc_z[-5:]
    # print('roll')
    # print(roll)
    # print(yaw)
    # print(cpu_ticks_l)



# Clearing Axes and Plotting
    ax1.cla()  # clear axes it won't change the colour of lines
    ax2.cla()

    # Formatting plot
    ax1.set_title('Gyro')
    ax1.set_ylabel('Roll, Yaw, Pitch (rad/sec)')
    ax1.set_xlabel('CPU_Time (ms)')

    ax2.set_title('Acceleration')
    ax2.set_ylabel('Acceleration (m/sec^2)')
    ax2.set_xlabel('CPU_Time (ms)')

    #labelling and legends
    
    ax1.plot(cpu_ticks_l, roll, label='Roll')
    ax1.plot(cpu_ticks_l, pitch, color='#444444', linestyle='--', label='Pitch')
    ax1.plot(cpu_ticks_l, yaw, linestyle='-.', label='Yaw')
    ax1.legend(loc='upper left')

    ax2.plot(cpu_ticks_l, acc_x, label='Acc(x)')
    ax2.plot(cpu_ticks_l, acc_y, linestyle='--', label='Acc(y)')
    ax2.plot(cpu_ticks_l, acc_z, linestyle='-.', label='Acc(z)')
    ax2.legend(loc='upper left')


print("Calling Func animation")
ani = FuncAnimation(plt.gcf(), animate, fargs=(Roll, Pitch, Yaw, Acc_x, Acc_y, Acc_z, CPU_ticks_l), interval=10)

plt.tight_layout()
plt.show()
print("showing plot")

