#include "RssiMessages.h"
#include "AM.h"
module UnknownC {
  uses interface Boot;
  uses interface Timer<TMilli> as SendTimer;
  uses interface Packet;
  uses interface Read<uint16_t> as ReadRssi;
  uses interface AMSend as RssiMsgSend;
  uses interface SplitControl as RadioControl;
} 
implementation {
  message_t message;
  bool busy=FALSE;
  event void Boot.booted(){
    call RadioControl.start();
  }
  event void RadioControl.startDone(error_t result){
    call SendTimer.startPeriodic(SEND_INTERVAL_MS);
  }
  event void RadioControl.stopDone(error_t result){}
  event void SendTimer.fired(){
      call ReadRssi.read();
  }
  event void ReadRssi.readDone(error_t result, uint16_t val ){
      if(busy==FALSE){
          RssiMsg *rssiMsg;
          rssiMsg = (RssiMsg*) (call Packet.getPayload(&message, sizeof (RssiMsg)));
          rssiMsg->rssi = val;
          rssiMsg->senderID = TOS_NODE_ID;
          rssiMsg->targetID = AM_BROADCAST_ADDR;
          if(call RssiMsgSend.send(AM_BROADCAST_ADDR, &message, sizeof(RssiMsg))==SUCCESS){
              busy=TRUE;
          }
       }
  }
  event void RssiMsgSend.sendDone(message_t *m, error_t error){
      if(&message==m){
          busy=FALSE;
      }
  }
}