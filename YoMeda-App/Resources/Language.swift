import Foundation
import UIKit

class Language {
    static let shared: Language = Language()
    
    class func currentLanguage()->String {
        let def = UserDefaults.standard
        let lang = def.object(forKey: "AppleLanguages") as! NSArray
        let currentLanguage = lang.firstObject as! String
        return currentLanguage
    }
    
    class func setAppLanguage(language:String) {
        let def = UserDefaults.standard
        def.set([language,currentLanguage()], forKey: "AppleLanguages")
        UserDefaults.standard.set(language, forKey: "i18n_language")
        def.synchronize()
        switch language {
        case "ar": // Arabic -- 1
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance().textAlignment = .right
            UITextView.appearance().textAlignment = .right
            UITableView.appearance().semanticContentAttribute = .forceRightToLeft
            UICollectionView.appearance().semanticContentAttribute = .forceRightToLeft
            UIButton.appearance().semanticContentAttribute = .forceRightToLeft
            
            UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
            UserDefaults.standard.set("ar", forKey: "defaultLanguage")
            break
        default:   // default language English -- 2
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
            UITextField.appearance().textAlignment = .left
            UITextView.appearance().textAlignment = .left
            UITableView.appearance().semanticContentAttribute = .forceLeftToRight
            UICollectionView.appearance().semanticContentAttribute = .forceLeftToRight
            UIButton.appearance().semanticContentAttribute = .forceLeftToRight
            UILabel.appearance().semanticContentAttribute = .forceLeftToRight
            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
            
            UserDefaults.standard.set("en", forKey: "defaultLanguage")
            break
        }
        
        UIView.localize()
        
    }
    
    class func localizeStringForKey(word:String)->String{
        let localizedWord = NSLocalizedString(word, comment: "")
        return localizedWord
    }
    ////// to get language flage
    class func getLangFlage()->Int {
        
        switch Language.currentLanguage() {
        case "ar": // Arabic -- 1
            return 1
        case "en": // English -- 2
            return 2
        default:   // default language English -- 2
            return 2
        }
        
    }
    class func showLanguageActionSheet(_ view: UIViewController){
        let alert = UIAlertController(title: "Choose Language", message: "Please choose your preferred language", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "English", style: .default, handler: { (_) in
            print("User click English button")
            Language.setAppLanguage(language: "en")
            view.toroot()
        }))
        
        alert.addAction(UIAlertAction(title: "Arabic", style: .default, handler: { (_) in
            print("User click Arabic button")
            Language.setAppLanguage(language: "ar")
            view.toroot()
            print(Language.currentLanguage())
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        view.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
}
// MARK: Swizzling
extension UIView {
    static func localize() {
        
        let orginalSelector = #selector(awakeFromNib)
        let swizzledSelector = #selector(swizzledAwakeFromNib)
        
        let orginalMethod = class_getInstanceMethod(self, orginalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, orginalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(orginalMethod!), method_getTypeEncoding(orginalMethod!))
        } else {
            method_exchangeImplementations(orginalMethod!, swizzledMethod!)
        }
        
    }
    
    @objc func swizzledAwakeFromNib() {
        swizzledAwakeFromNib()
        
        switch self {
        case let txtf as UITextField:
            txtf.placeholder = txtf.placeholder?.localiz()
        case let lbl as UILabel:
            lbl.text = lbl.text?.localiz()
        case let btn as UIButton:
            btn.setTitle(btn.title(for: .normal)?.localiz(), for: .normal)
            // case let txtf as UIImageView:
            // txtf.image =   txtf.image?.imageFlippedForRightToLeftLayoutDirection()
        default:
            break
        }
    }
}


// MARK: String extension
extension String {
    
    ///
    /// Localize the current string to the selected language
    ///
    /// - returns: The localized string
    ///
    func localiz() -> String {
        guard let bundle = Bundle.main.path(forResource: Language.currentLanguage(), ofType: "lproj") else {
            return NSLocalizedString(self, comment: "")
        }
        
        let langBundle = Bundle(path: bundle)
        return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: "")
    }
}

