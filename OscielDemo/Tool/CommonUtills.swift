//
//  CommonUtills.swift
//  OscielDemo
//
//  Created by Desarrollo on 4/9/20.
//  Copyright © 2020 Desarrollo. All rights reserved.
//

import Foundation
import UIKit

final class CommonUtils {
    
    private init() {
        
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func formatRedableDate(date: String) -> String {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date2: Date? = dateFormatter.date(from: dateString )
        let dformat = DateFormatter()
        dformat.dateFormat = "MMM d, yyyy"
        if let aDate2 = date2 {
            return dformat.string(from: aDate2)
        } else {
            return ""
        }
    }
    
    static func todaysDate() -> String {
        let todaysDate: Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: todaysDate)
    }
    
    static func lastMonth() -> String {
        let todaysDate: Date = Date()
        let lastMonthDate = todaysDate - 30
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: lastMonthDate)
    }
    
    static func currentMonth() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "es_MX") as Locale
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date as Date)
    }
    
    static func isValidEmailAddress(emailAddressString:String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx )
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range :NSRange(location:0,length: nsString.length))
            if results.count == 0 {
                returnValue = false
            }
        } catch _ as NSError {
            returnValue = false
        }
        return returnValue
    }
    
    static func validatePhone(phoneNumber: String?) -> Bool {
        let phoneRegex = "[0-9]{8,12}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    static func presentAlert(message: String, title: String, origin: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
        }
        alertController.addAction(OKAction)
        origin.present(alertController, animated: true, completion:nil)
    }
    
}

extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    var removeOptional: String {
        let a: String = self.replacingOccurrences(of: "Optional(\"", with: "")
        let b: String = a.replacingOccurrences(of: "\")", with: "")
        let c: String = b.replacingOccurrences(of: "Optional(", with: "")
        let d: String = c.replacingOccurrences(of: ")", with: "")
        return d
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var intValue: Int {
        return Int((self as NSString).intValue)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}

