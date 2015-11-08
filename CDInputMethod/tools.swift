//
//  DecodeHTML.swift
//  CDInput
//
//  Created by catbaron on 15/11/1.
//  Copyright © 2015年 catbaron. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var htmlToString:String? {
        do{
        return try NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil).string
        }catch{
            print(error)
            return nil
        }
    }
    
    var htmlToNSAttributedString:NSAttributedString? {
        do {
         return try NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        }catch{
            print(error)
            return nil
        }
    }
}

func getWiFiAddress() -> String? {
    var address : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
    if getifaddrs(&ifaddr) == 0 {
        
        // For each interface ...
        for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
            let interface = ptr.memory
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.memory.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                if let name = String.fromCString(interface.ifa_name) where name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.memory
                    var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.memory.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
                    address = String.fromCString(hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    
    return address
}
