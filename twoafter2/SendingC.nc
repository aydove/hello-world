#include "RssiMessages.h"
#include "AM.h"
module SendingC {
  uses interface Boot;
  uses interface Packet;
  uses interface AMSend as RssiMsgSend;
  uses interface SplitControl as RadioControl;
  uses interface Receive;
  uses interface CC2420Packet;
} 
implementation {
  message_t message;
  bool busy;
  uint16_t getRssi(message_t *msg);
  event message_t* Receive.receive(message_t *msg, void *payload, uint8_t len) {
      if(len==sizeof(RssiMsg)){
          RssiMsg* pkg=(RssiMsg*)payload;
          if(pkg->targetID == AM_BROADCAST_ADDR&&busy==FALSE){
              RssiMsg *rssiMsg = (RssiMsg*) (call Packet.getPayload(&message, sizeof (RssiMsg)));
              rssiMsg->rssi = getRssi(msg);
              rssiMsg->senderID = pkg->senderID;
              rssiMsg->targetID = pkg->targetID;
              if(call RssiMsgSend.send(0, &message, sizeof(RssiMsg))==SUCCESS){
                  busy=TRUE;
              }
          }
      }
      return msg;
  }
  event void Boot.booted(){
    busy=FALSE;
    call RadioControl.start();
  }
  event void RadioControl.startDone(error_t result){
    if(result!=SUCCESS){
        call RadioControl.start();
    }
  }
  event void RadioControl.stopDone(error_t result){}
  event void RssiMsgSend.sendDone(message_t *m, error_t error){
      if(&message==m){
          busy=FALSE;
      }
  }
  uint16_t getRssi(message_t *msg){
      return (uint16_t) call CC2420Packet.getRssi(msg);
  }
}