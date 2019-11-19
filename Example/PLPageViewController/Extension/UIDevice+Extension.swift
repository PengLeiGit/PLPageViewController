//
//  UIDevice+Extension.swift
//  PLPageViewController_Example
//
//  Created by 彭磊 on 2019/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {

    
    /// 屏幕的比例
    public static let scale: CGFloat               = UIScreen.main.scale

    /// UI尺寸针对width == 375，缩放
    public static let zoomUI: CGFloat              = UIScreen.main.bounds.size.width / 375
    
    ///屏幕宽
    public static let width: CGFloat               = UIScreen.main.bounds.size.width
   
    ///屏幕高
    public static let height: CGFloat              = UIScreen.main.bounds.size.height
    
    ///状态栏高度
    public static let statusBarHeight: CGFloat     = UIApplication.shared.statusBarFrame.height
    
    /// tabbar的高度
    public static let tabBarHeight: CGFloat        = 49 + bottomSafeAreaHeight
    
    ///导航栏高度
    public static let navigationBarHeight: CGFloat = 44 + statusBarHeight
    
    /// 顶部安全区域的高度 (20 or 44)
    public static let topSafeAreaHeight: CGFloat   = UIDevice.safeAreaInsets().top

    /// 底部安全区域 (0 or 34)
    public static let bottomSafeAreaHeight: CGFloat = UIDevice.safeAreaInsets().bottom
    
    
    private static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        if #available(iOS 11.0, *) {
            
            let inset = UIApplication.shared.delegate?.window??.safeAreaInsets
            
            let top = inset?.top ?? 0
            
            return (top == 0 ? 20 : top, inset?.bottom ?? 0)
        } else {
            return (20, 0)
        }
    }
}

extension UIDevice {
    
    /// 版本号
    public static let appVersion     = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
    /// 构建号
    public static let appbBuild      = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? ""
    /// app的名称
    public static let appName        = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String ?? ""
    /// 工程名
    public static let appProjectName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? ""
    /// 通用唯一识别码UUID
    public static let appUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""

    ///获取系统名称
    public static let systemName = UIDevice.current.systemName
    
    ///获取设备名称 如 XXX的iphone
    public static let deviceUserName = UIDevice.current.name
}

extension UIDevice {
    
    /// 获取app的缓存
    public static func jk_cacheSize() -> String {
        return UIDevice.cacheSize()
    }
    
    /// 清空缓存
    public static func jk_cleanCache() {
        return UIDevice.cleanCache()
    }

    
    /// 获取电池电量
    public static func jk_batteryLevel() -> CGFloat {
        return CGFloat(UIDevice.current.batteryLevel)
    }
    
    
    ///获取总的内存
    public static  func jk_getDiskTotalSize() -> String {
        return fileSizeToString(fileSize: getTotalDiskSize())
    }
    
    ///获取可用的内存
    public static  func jk_getAvalibleDiskSize() -> String {
        return fileSizeToString(fileSize: getAvailableDiskSize())
    }
    
    
    /// 获取当前设备IP
    public static  func jk_getDeviceIP() -> String {
        return deviceIP()
    }
    

    ///获取设备名称
    public static  func jk_getDeviceName() -> String {
        return deviceName()
    }
}


extension UIDevice {
    
    
    /// 获取该app的缓存
    private static func cacheSize() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        var size = 0
        for file in fileArr! {
            let path = cachePath! + "/\(file)"
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).integerValue
                }
            }
        }
        let mm = size / 1024 / 1024
        return String(mm) + "M"
    }
    
    /// 清理该app的缓存
    private static func cleanCache() {
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = cachePath! + "/\(file)"
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch { }
            }
        }
    }
 
    /// 获取当前设备IP
    private class func deviceIP() -> String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        if let ipStr = addresses.first {
            return ipStr
        } else {
            return ""
        }
    }
    
    
    ///获取设备名称
    private class func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            
        case "iPod1,1":                             return "iPod Touch 1G"
        case "iPod2,1":                             return "iPod Touch 2G"
        case "iPod3,1":                             return "iPod Touch 3G"
        case "iPod4,1":                             return "iPod Touch 4G"
        case "iPod5,1":                             return "iPod Touch (5 Gen)"
        case "iPod7,1":                             return "iPod touch 6G"
            
        ///iphone
        case "iPhone1,1":                           return "iPhone 1G"
        case "iPhone1,2":                           return "iPhone 3G"
        case "iPhone2,1":                           return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1":                           return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":              return "iPhone 5"
        case "iPhone5,3","iPhone5,4":               return "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":              return "iPhone 5S"
        case "iPhone7,1":                           return "iPhone 6 Plus"
        case "iPhone7,2":                           return "iPhone 6"
        case "iPhone8,1":                           return "iPhone 6s"
        case "iPhone8,2":                           return "iPhone 6s Plus"
        case "iPhone8,4":                           return "iPhone SE"
        case "iPhone9,1","iPhone9,3":               return "iPhone 7"
        case "iPhone9,2","iPhone9,4":               return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":             return "iPhone 8"
        case "iPhone10,2","iPhone10,5":             return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":             return "iPhone X"
        case "iPhone11,8":                          return "iPhone XR"
        case "iPhone11,2":                          return "iPhone XS"
        case "iPhone11,6":                          return "iPhone XS Max"
            
        ///iPad
        case "iPad1,1":                             return "iPad"
        case "iPad1,2":                             return "iPad 3G"
        case "iPad2,1":                             return "iPad 2 (WiFi)"
        case "iPad2,2":                             return "iPad 2"
        case "iPad2,3":                             return "iPad 2 (CDMA)"
        case "iPad2,4":                             return "iPad 2"
        case "iPad2,5":                             return "iPad Mini (WiFi)"
        case "iPad2,6":                             return "iPad Mini"
        case "iPad2,7":                             return "iPad Mini (GSM+CDMA)"
        case "iPad3,1":                             return "iPad 3 (WiFi)"
        case "iPad3,2":                             return "iPad 3 (GSM+CDMA)"
        case "iPad3,3":                             return "iPad 3"
        case "iPad3,4":                             return "iPad 4 (WiFi)"
        case "iPad3,5":                             return "iPad 4"
        case "iPad3,6":                             return "iPad 4 (GSM+CDMA)"
        case "iPad4,1":                             return "iPad Air (WiFi)"
        case "iPad4,2":                             return "iPad Air (Cellular)"
        case "iPad4,4":                             return "iPad Mini 2 (WiFi)"
        case "iPad4,5":                             return "iPad Mini 2 (Cellular)"
        case "iPad4,6":                             return "iPad Mini 2"
        case "iPad4,7":                             return "iPad Mini 3"
        case "iPad4,8":                             return "iPad Mini 3"
        case "iPad4,9":                             return "iPad Mini 3"
        case "iPad5,1":                             return "iPad Mini 4 (WiFi)"
        case "iPad5,2":                             return "iPad Mini 4 (LTE)"
        case "iPad5,3":                             return "iPad Air 2"
        case "iPad5,4":                             return "iPad Air 2"
        case "iPad6,3":                             return "iPad Pro 9.7"
        case "iPad6,4":                             return "iPad Pro 9.7"
        case "iPad6,7":                             return "iPad Pro 12.9"
        case "iPad6,8":                             return "iPad Pro 12.9"
        case "iPad6,11":                            return "iPad 5 (WiFi)"
        case "iPad6,12":                            return "iPad 5 (Cellular)"
        case "iPad7,1":                             return "iPad Pro 12.9 inch 2nd gen (WiFi)"
        case "iPad7,2":                             return "iPad Pro 12.9 inch 2nd gen (Cellular)"
        case "iPad7,3":                             return "iPad Pro 10.5 inch (WiFi)"
        case "iPad7,4":                             return "iPad Pro 10.5 inch (Cellular)"
        case "iPad7,5","iPad7,6":                   return "iPad (6th generation)"
        case "iPad8,1","iPad8,2","iPad8,3","iPad8,4":  return "iPad Pro (11-inch)"
        case "iPad8,5","iPad8,6","iPad8,7","iPad8,8":  return "iPad Pro (12.9-inch) (3rd generation)"
            
        //Apple Watch
        case "Watch1,1","Watch1,2":                 return "Apple Watch (1st generation)"
        case "Watch2,6","Watch2,7":                 return "Apple Watch Series 1"
        case "Watch2,3","Watch2,4":                 return "Apple Watch Series 2"
        case "Watch4,1","Watch4,2","Watch4,3","Watch4,4":    return "Apple Watch Series 3"
        case "Watch3,1","Watch3,2","Watch3,3","Watch3,4":    return "Apple Watch Series 4"
            
            
        ///AppleTV
        case "AppleTV2,1":                          return "Apple TV 2"
        case "AppleTV3,1":                          return "Apple TV 3"
        case "AppleTV3,2":                          return "Apple TV 3"
        case "AppleTV5,3":                          return "Apple TV 4"
        case "AppleTV6,2":                          return "Apple TV 4K"
            
        ///AirPods
        case "AirPods1,1":                          return "AirPods"
            
        ///Simulator
        case "i386":                                return "Simulator"
        case "x86_64":                              return "Simulator"
            
        default:                                    return "unknow"
        }
    }
    
    private class func blankof<T>(type:T.Type) -> T {
        let ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
        let val = ptr.pointee
        return val
    }
    
    /// 磁盘总大小
    private class func getTotalDiskSize() -> Int64 {
        var fs = blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_blocks)
        }
        return -1
    }
    
    /// 磁盘可用大小
    private class func getAvailableDiskSize() -> Int64 {
        var fs = blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_bavail)
        }
        return -1
    }
    
    /// 将大小转换成字符串用以显示
    private class func fileSizeToString(fileSize:Int64) -> String {
        
        let fileSize1 = CGFloat(fileSize)
        
        let KB:CGFloat = 1024
        let MB:CGFloat = KB*KB
        let GB:CGFloat = MB*KB
        
        if fileSize < 10 {
            return "0 B"
            
        } else if fileSize1 < KB {
            return "< 1 KB"
        } else if fileSize1 < MB {
            return String(format: "%.1f KB", CGFloat(fileSize1)/KB)
        } else if fileSize1 < GB {
            return String(format: "%.1f MB", CGFloat(fileSize1)/MB)
        } else {
            return String(format: "%.1f GB", CGFloat(fileSize1)/GB)
        }
    }
}
