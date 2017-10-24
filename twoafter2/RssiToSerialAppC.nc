#include "RssiMessages.h"
configuration RssiToSerialAppC {}
implementation {
  components MainC, RssiToSerialC as App, LedsC;
  components new TimerMilliC();
  components SerialActiveMessageC as AM;
  components ActiveMessageC;
  App.Boot -> MainC.Boot;
  App.SerialControl -> AM;
  App.Receive -> ActiveMessageC.Receive[AM_RSSIMSG];
  App.AMSend -> AM.AMSend[AM_RSSIMSG];
  App.AMControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.Packet -> AM;
  App.RadioAMPacket -> ActiveMessageC;
  App.UartAMPacket -> AM;
}