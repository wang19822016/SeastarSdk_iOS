//
//  GocpaSDKUtilities.m
//  gocpaSDKSample
//
//  Created by seanwong on 13-8-18.
//  Copyright (c) 2013年 gocpa. All rights reserved.
//
#import "GocpaUtilities.h"
#import <Foundation/NSData.h>
#include <sys/socket.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <arpa/inet.h>
#include <net/ethernet.h>

#include <sys/sysctl.h>
#include <net/if_dl.h>
#import "UIDevice-Hardware.h"
#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import<CoreTelephony/CTCarrier.h>

#import <AdSupport/ASIdentifierManager.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation GocpaUtilities

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4,  IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;

    NSDictionary *addresses = [GocpaUtilities getIPAddresses];
    NSLog(@"addresses: %@", addresses);

    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
        {
            address = addresses[key];
            if(address) *stop = YES;
        } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


+ (NSString *) getIP {
/*2016-8-15 ipv6 issue
	NSString *result = nil;
    
	struct ifaddrs*	addrs;
	BOOL success = (getifaddrs(&addrs) == 0);
	if (success)
	{
		const struct ifaddrs* cursor = addrs;
		while (cursor != NULL)
		{
			NSMutableString* ip;
			NSString* interface = nil;
			if (cursor->ifa_addr->sa_family == AF_INET)
			{
				const struct sockaddr_in* dlAddr = (const struct sockaddr_in*) cursor->ifa_addr;
				const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;
				ip = [NSMutableString new];
				for (int i = 0; i < 4; i++)
				{
					if (i != 0)
						[ip appendFormat:@"."];
					[ip appendFormat:@"%d", base[i]];
				}
				interface = [NSString stringWithFormat:@"%s", cursor->ifa_name];
				if([interface isEqualToString:@"en0"] && result == nil) {
					result = [ip copy];
				}
				if(![interface isEqualToString:@"lo0"] && ![interface isEqualToString:@"en0"] && ![interface isEqualToString:@"fw0"] && ![interface isEqualToString:@"en1"] ) {
					result = [ip copy];
				}
                
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
    
	if (result == nil) {
        result = @"127.0.0.1";
    }
    
	return result;*/
	
	return [GocpaUtilities getIPAddress:YES];	//ipv6 solution
}
+(NSString*)getOperator{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *countryCode = [carrier mobileCountryCode];

    NSString *mobilecode = [carrier mobileNetworkCode];
    
    
    //NSLog(@"code:%@",code);
    /*NSString*ret=@"Unknown";
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        
        ret = @"ChinaMobile";
    }
    
    if ([code isEqualToString:@"01"]|| [code isEqualToString:@"06"] ) {
        ret = @"ChinaUnicom";
    }
    
    if ([code isEqualToString:@"03"]|| [code isEqualToString:@"05"] ) {
        ret = @"ChinaTelecom";;
    }
    return ret;*/
    return [NSString stringWithFormat:@"%@%@",countryCode,mobilecode];
}


+(NSString*)getSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}
+(NSString*)getDeviceModel{
    return [[UIDevice currentDevice] modelName];
}

+ (NSString *) getMacAddress {
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) {
        errorFlag = @"if_nametoindex failure";
    }
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) {
        errorFlag = @"sysctl mgmtInfoBase failure";
    }
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL) {
        errorFlag = @"buffer allocation failure";
    }
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    return errorFlag;
}

+ (NSString *)urlencode:(NSString*)inputstring {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[inputstring UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+(NSString*)getAdvertisingId{
    if (!NSClassFromString(@"ASIdentifierManager")) {
        //return [UIDevice currentDevice].uniqueIdentifier;
        return @"";
    }
    NSString *uniqueString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    return uniqueString;
    //return @"";
}

+(NSString*)getDeviceCountry{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode;
}

+(Boolean)getiAd{
    __block Boolean _result=false;

/*
    // Get a reference to the shared ADClient object instance
    ADClient * sharedInstance = [ADClient sharedClient];
    // Check to see if we were installed as the result of an iAd campaign
    [sharedInstance determineAppInstallationAttributionWithCompletionHandler:^(BOOL appInstallationWasAttributedToiAd) 	{
        // If we're installed from an iAd campaign

        if(appInstallationWasAttributedToiAd == YES) {
            
            _result = true;

        }
    }];
    */
    return _result;
}
@end
