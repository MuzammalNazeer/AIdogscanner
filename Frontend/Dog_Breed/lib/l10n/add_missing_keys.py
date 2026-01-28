
import json
import os
import glob

missing_keys = {
    "dialogGot_it": "Got it",
    "actionAddVeterinary": "+ Add veterinary",
    "labelCountry": "Country",
    "labelCity": "City",
    "shareMessageBody": "Check out Dog Breed - an amazing app for dog lovers!",
    "shareIOS": "📱 Discover Dog Breed on the App Store!",
    "shareAndroid": "📱 Get Dog Breed on Google Play!",
    "shareDefault": "📱 Check out Dog Breed!",
    "shareSubject": "Dog Breed App"
}

l10n_dir = r"d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n"
arb_files = glob.glob(os.path.join(l10n_dir, "app_*.arb"))

for file_path in arb_files:
    file_name = os.path.basename(file_path)
    if file_name == "app_en.arb":
        continue
        
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
            
        modified = False
        for key, value in missing_keys.items():
            if key not in data:
                data[key] = value
                print(f"Added {key} to {file_name}")
                modified = True
                
        if modified:
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=4, ensure_ascii=False)
                
    except Exception as e:
        print(f"Error processing {file_name}: {e}")
