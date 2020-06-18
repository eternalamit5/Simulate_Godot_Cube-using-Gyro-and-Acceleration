/*
 * TCPIPServer.h
 *
 *  Created on: Jun 15, 2020
 *      Author: biba
 */

#ifndef TCPIPSERVER_H_
#define TCPIPSERVER_H_


#include <stdio.h>
#include <string.h> //strlen
#include <stdlib.h>
#include <errno.h>
#include <unistd.h> //close
#include <arpa/inet.h> //close
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/time.h> //FD_SET, FD_ISSET, FD_ZERO macros
#include <iostream>
#include <fstream>
#include <string.h>
#include <cstddef>

#define TRUE 1
#define FALSE 0
#define PORT 8888
# define GYRO_DATA_PATH "../../gyrodata.txt"
# define ACC_DATA_PATH "../../acc1.txt"



#endif /* TCPIPSERVER_H_ */
