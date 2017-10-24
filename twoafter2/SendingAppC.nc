#include "RssiMessages.h"
#include "message.h"
configuration SendingAppC {
} implementation {
  components ActiveMessageC, MainC;  
  components new AMSenderC(AM_RSSIMSG) as RssiMsgSender;
  components SendingC as App;
  components CC2420ActiveMessageC;
  App.Boot -> MainC;
  App.Packet -> ActiveMessageC;
  App.RssiMsgSend -> RssiMsgSender;
  App.RadioControl -> ActiveMessageC;
  App.Receive -> ActiveMessageC.Receive[AM_RSSIMSG];
  App -> CC2420ActiveMessageC.CC2420Packet;
}