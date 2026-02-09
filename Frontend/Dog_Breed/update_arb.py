import json
import os

arb_file_path = r'd:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n\app_en.arb'

new_keys = {
 "editProfile": "Edit Profile", 
 "profileRecentScan": "Recent Scans", 
 "profileHistory": "Scan History", 
 "notifications": "Notifications", 
 "appLanguageTitle": "App Language", 
 "premiumSubscription": "Premium Subscription", 
 "profileMyFavorites": "My Favorites", 
 "feedbackTitle": "Feedback", 
 "rateUsTitle": "Rate Us", 
 "shareTitle": "Share App", 
 "faq": "FAQ", 
 "termsOfUse": "Terms of Use", 
 "privacyPolicy": "Privacy Policy", 
 "deleteOwnerProfile": "Delete Profile", 
 "logout": "Logout", 
 "themeTitle": "Theme", 
 "darkTheme": "Dark", 
 "lightTheme": "Light", 
 "aiAppName": "Dog Breed Scanner", 
 "shareMessageBody": "Check out Dog Breed Scanner - AI-powered dog breed identification app! 🐕", 
 "shareIOS": "Check out Dog Breed Scanner on the App Store!", 
 "shareAndroid": "Check out Dog Breed Scanner on Google Play!", 
 "shareDefault": "Check out Dog Breed Scanner!", 
 "shareDownloadNow": "Download now: ", 
 "shareSubject": "Dog Breed Scanner App", 
 "shareApp": "Share App", 
 "copy": "Copy", 
 "whatsapp": "WhatsApp", 
 "more": "More", 
 "copyLink": "Copy Link", 
 "shareWhatsApp": "Share via WhatsApp", 
 "shareEmail": "Share via Email", 
 "shareSMS": "Share via SMS", 
 "chooseShare": "Choose how to share:", 
 "linkCopied": "Link copied to clipboard", 
 "copyFailed": "Failed to copy link", 
 "enjoyingApp": "Are you enjoying Dog Breed Scanner?", 
 "tapToRate": "Tap a star to rate your experience", 
 "rateUsAction": "Submit Rating", 
 "selectStars": "Select Stars First", 
 "dialogCancel": "Cancel", 
 "dialogDelete": "Delete", 
 "dialogLogoutTitle": "Are you sure you want to logout?", 
 "dialogShareTitle": "Share {appName}", 
 "no": "No", 
 "yes": "Yes", 
 "deleteProfileWarning": "Are you sure you want to delete your profile? This action cannot be undone and all your data will be permanently removed.", 
 "errorLaunchUrl": "Could not launch {url}", 
 "errorShare": "Failed to share: {error}", 
 "errorAppStore": "Could not open app store", 
 "errorOpenStore": "Unable to open store", 
 "loading": "Loading..."
}

# Metadata for keys with placeholders
metadata = {
    "@dialogShareTitle": {
        "placeholders": {
            "appName": {
                "type": "String"
            }
        }
    },
    "@errorLaunchUrl": {
        "placeholders": {
            "url": {
                "type": "String"
            }
        }
    },
    "@errorShare": {
        "placeholders": {
            "error": {
                "type": "Object"
            }
        }
    }
}

try:
    with open(arb_file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Update keys
    for key, value in new_keys.items():
        data[key] = value
        
    # Update metadata if needed
    for key, value in metadata.items():
        if key not in data:
            data[key] = value
            
    # Ensure location keys exist (as requested)
    location_keys = {
        "country": "Country",
        "city": "City",
        "hintEnterCity": "Enter your city",
        "errorEnterCity": "Please enter your city"
    }
    
    for key, value in location_keys.items():
        if key not in data:
            print(f"Adding missing location key: {key}")
            data[key] = value
            
    with open(arb_file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
        
    print("Successfully updated app_en.arb")
    
except Exception as e:
    print(f"Error: {e}")
