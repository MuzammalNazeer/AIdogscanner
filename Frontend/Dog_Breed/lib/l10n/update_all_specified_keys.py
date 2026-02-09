import json
import os

l10n_dir = r"d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n"

# Files to update
target_files = [
    "app_en.arb", "app_de.arb", "app_es.arb", "app_fr.arb", 
    "app_id.arb", "app_it.arb", "app_nl.arb", "app_pt.arb", 
    "app_tr.arb", "app_el.arb", "app_sv.arb", "app_da.arb", 
    "app_cs.arb", "app_fi.arb", "app_pl.arb"
]

new_values = {
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

def update_file(filename):
    file_path = os.path.join(l10n_dir, filename)
    if not os.path.exists(file_path):
        print(f"Skipping {filename} (not found)")
        return

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading {filename}: {e}")
        return

    updated_count = 0
    added_count = 0

    for key, value in new_values.items():
        if key in data:
            if data[key] != value:
                # Update existing key
                data[key] = value
                updated_count += 1
        else:
            # Add new key
            data[key] = value
            added_count += 1

    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
    
    print(f"Updated {filename}: Added {added_count}, Updated {updated_count}")

for filename in target_files:
    update_file(filename)
