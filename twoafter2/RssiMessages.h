#ifndef RSSIMESSAGES_H__
#define RSSIMESSAGES_H__
enum {
	SEND_INTERVAL_MS = 2000, AM_RSSIMSG = 10
};
typedef nx_struct RssiMsg{
	nx_int16_t rssi;
	nx_int8_t senderID;
	nx_int8_t targetID;
} RssiMsg;
#endif //RSSIMESSAGES_H__