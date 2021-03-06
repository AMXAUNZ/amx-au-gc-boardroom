program_name='wake-on-lan'

#if_not_defined __WAKE_ON_LAN__
#define __WAKE_ON_LAN__

define_constant

char strWakeOnLanVersion[] = 'v1.0.0'

#include 'amx-device-control'


/*
 * --------------------
 * Wake On Lan devices
 * --------------------
 */

define_device

#warn 'PROGRAMMERS NOTE: wake-on-lan - Define the IP socket in the main program (above the include of wake-on-lan.axi)'
#if_not_defined dvIpSocketWakeOnLan
dvIpSocketWakeOnLan = 0:3:0
#end_if

/*
 * --------------------
 * Wake On Lan constants
 * --------------------
 */

define_constant

integer WAKE_ON_LAN_MAGIC_PACKET_BYTE_SIZE  = 102

integer WAKE_ON_LAN_UDP_LISTENING_PORT      = 9 // udp port 7 also works for WOL

char WAKE_ON_LAN_MAGIC_PACKET_HEADER[]      = {$FF,$FF,$FF,$FF,$FF,$FF}

char WAKE_ON_LAN_BROADCAST_ADDRESS[]        = '255.255.255.255'


/*
 * --------------------
 * Wake On Lan variables
 * --------------------
 */

define_variable

integer waitTimeSendWakeOnLanPacketAfterOpeningUdpSocket = 0


/*
 * --------------------
 * Wake On Lan functions
 * --------------------
 */


/*
 * --------------------
 * Function: wakeOnLan
 *
 * Parameters:  char macAddress[] - mac address (in raw hex form, not ASCII)
 * 
 * Description: Builds and sends a Wake-On-Lan magic packet. Uses 255.255.255.255 as
 *              the broadcast address.
 * --------------------
 */
define_function wakeOnLan (char macAddress[])
{
	local_var char wakeOnLanMagicPacket[102]   // need to be a local_var to go inside wait statement
	stack_var integer i
	
	wakeOnLanMagicPacket = "WAKE_ON_LAN_MAGIC_PACKET_HEADER"
	
	for (i = 1; i <= 16; i++)
	{
		wakeOnLanMagicPacket = "wakeOnLanMagicPacket,macAddress"
	}
	
	ip_client_open (dvIpSocketWakeOnLan.port, WAKE_ON_LAN_BROADCAST_ADDRESS, WAKE_ON_LAN_UDP_LISTENING_PORT, IP_UDP)
	sendString (dvIpSocketWakeOnLan, wakeOnLanMagicPacket)
	ip_client_close (dvIpSocketWakeOnLan.port)
}

/*
 * --------------------
 * Function: wakeOnLanSpecifyBroadcastAddress
 *
 * Parameters:  char macAddress[] - mac address (in raw hex form, not ASCII)
 *              char broadcastAddress[] - broadcast IP address
 * 
 * Description: Builds and sends a Wake-On-Lan magic packet.
 * --------------------
 */
define_function wakeOnLanSpecifyBroadcastAddress (char macAddress[], char broadcastAddress[])
{
	local_var char wakeOnLanMagicPacket[102]   // need to be a local_var to go inside wait statement
	stack_var integer i
	
	wakeOnLanMagicPacket = "WAKE_ON_LAN_MAGIC_PACKET_HEADER"
	
	for (i = 1; i <= 16; i++)
	{
		wakeOnLanMagicPacket = "wakeOnLanMagicPacket,macAddress"
	}
	
	ip_client_open (dvIpSocketWakeOnLan.port, broadcastAddress, WAKE_ON_LAN_UDP_LISTENING_PORT, IP_UDP)
	sendString (dvIpSocketWakeOnLan, wakeOnLanMagicPacket)
	ip_client_close (dvIpSocketWakeOnLan.port)
}

#end_if