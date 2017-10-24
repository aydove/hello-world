#include "Timer.h"
#include "AM.h"
#include "Serial.h"
#include "RssiMessages.h"
module RssiToSerialC {
  uses {
    interface Leds;
    interface Boot;
    interface AMSend;
    interface SplitControl as AMControl;
    interface SplitControl as SerialControl;
    interface Packet;
    interface Receive;
    interface AMPacket as RadioAMPacket;
    interface AMPacket as UartAMPacket;
  }
}
implementation {
  message_t packet;
  event void Boot.booted() {
    call AMControl.start();
    call SerialControl.start();
  }
  event void AMControl.startDone(error_t err) {
    if (err != SUCCESS) {
      call AMControl.start();
    }
  }
  event void AMControl.stopDone(error_t err) {}
  event void SerialControl.startDone(error_t error){
    if (error != SUCCESS) {
      call SerialControl.start();
    }
  }
  event void SerialControl.stopDone(error_t error){}
  event void AMSend.sendDone(message_t* msg, error_t error) {
    if(error == SUCCESS){
       call Leds.led1Toggle();
    }
  }
  event message_t* Receive.receive(message_t *msg, void *payload, uint8_t len) {
      if(len==sizeof(RssiMsg)){
          am_addr_t addr, src;
          am_group_t grp;
          message_t* msg1=msg;
          addr = call RadioAMPacket.destination(msg1);
          if(addr != AM_BROADCAST_ADDR){
              src = call RadioAMPacket.source(msg1);
              grp = call RadioAMPacket.group(msg1);
              call Packet.clear(msg1);
              call UartAMPacket.setSource(msg1, src);
              call UartAMPacket.setGroup(msg1, grp);
              if(call AMSend.send(addr, msg1, sizeof(RssiMsg))==SUCCESS){
                  call Leds.led1Toggle();
              }
          }
          return msg;
      }
      else{
          return NULL;
      }
  }
}