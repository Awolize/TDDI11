#include <os_cpu.h>
#include <os_cfg.h>
#include <ucos_ii.h> /* os_c??.h must be included before ! */
#include <libepc.h>

#include "inbound.h"
#include "elapsed.h"
#include "serial.h"

OS_EVENT* overpower = NULL;

void ReceivePackets(void)
{
  SerialInit() ;
  
  for (;;)
  {
    int type, byte, bytes ;
    BYTE8 *bfr ;
    
    if (SerialGet() != 0xFF)
      continue ;
    
    switch (type = SerialGet())
    {
      default:
        continue ;
      case 1:
      case 2:
        break ;
    }
    
    bytes = SerialGet();
    bfr = (BYTE8 *) malloc(bytes) ;
    if (!bfr)
    {
      for (;;)
        ;
    }
    
    for (byte = 0; byte < bytes; byte++)
    {
      bfr[byte] = SerialGet() ;
    }
    switch (type)
    {
      case 1:
        PostText(bfr) ;
        break ;
      case 2:
        PostTime(bfr) ;
        break ;
    }
  }
}

void SendPacket(int type, BYTE8 *bfr, int bytes)
{
    if (!overpower)
	overpower = OSSemCreate(1);

    OSSemPend(overpower, 0, NULL);
    SerialPut(0xFF);
    SerialPut(type);
    SerialPut(bytes);
    int i;
    for (i = 0; i < bytes; ++i) 
	SerialPut(bfr[i]);
    OSSemPost(overpower);
    
}

