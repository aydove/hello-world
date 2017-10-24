#include "RssiMessages.h"
#include "message.h"
configuration UnknownAppC {
} implementation {
  components ActiveMessageC, MainC;  
  components new AMSenderC(AM_RSSIMSG) as RssiMsgSender;
  components new TimerMilliC() as SendTimer;
  components CC2420ControlC;
  components UnknownC as App;
  App.Boot -> MainC;
  App.SendTimer -> SendTimer;
  App.Packet -> ActiveMessageC;
  App.ReadRssi -> CC2420ControlC.ReadRssi;
  App.RssiMsgSend -> RssiMsgSender;
  App.RadioControl -> ActiveMessageC;
}
