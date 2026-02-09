import json
import os

# Configuration
l10n_dir = r"d:\MyProjects\DogBreed\Frontend\Dog_Breed\lib\l10n"
master_file = "app_en.arb"
target_files = [
    "app_de.arb", "app_es.arb", "app_fr.arb", "app_id.arb", 
    "app_it.arb", "app_nl.arb", "app_pt.arb", "app_tr.arb", 
    "app_el.arb", "app_sv.arb", "app_da.arb", "app_cs.arb"
]

def update_arb_files():
    # Load master file
    master_path = os.path.join(l10n_dir, master_file)
    with open(master_path, 'r', encoding='utf-8') as f:
        master_data = json.load(f)
    
    print(f"Loaded master file: {master_file} with {len(master_data)} keys")

    for target_file in target_files:
        target_path = os.path.join(l10n_dir, target_file)
        
        if not os.path.exists(target_path):
            print(f"Warning: {target_file} not found. Skipping.")
            continue
            
        with open(target_path, 'r', encoding='utf-8') as f:
            try:
                target_data = json.load(f)
            except json.JSONDecodeError:
                print(f"Error decoding {target_file}. Skipping.")
                continue
        
        added_count = 0
        updated_count = 0
        
        # 1. Add missing keys from master
        for key, value in master_data.items():
            if key not in target_data:
                target_data[key] = value
                added_count += 1
            elif key == "rescannedSuccess":
                # 2. Fix rescannedSuccess placeholder if needed
                current_val = target_data[key]
                if "{breed}" in current_val and "{breedName}" not in current_val:
                    target_data[key] = current_val.replace("{breed}", "{breedName}")
                    # Update metadata if exists
                    if "@rescannedSuccess" in target_data:
                        meta = target_data["@rescannedSuccess"]
                        if "placeholders" in meta and "breed" in meta["placeholders"]:
                            meta["placeholders"]["breedName"] = meta["placeholders"].pop("breed")
                    updated_count += 1

        # 3. Ensure metadata keys (starting with @) are also copied if the parent key exists
        for key, value in master_data.items():
            if key.startswith("@"):
                parent_key = key[1:]
                if parent_key in target_data and key not in target_data:
                    target_data[key] = value
                    added_count += 1

        # 4. Remove duplicate keys (if any logic needed, but dict handles uniqueness)
        # However, we might want to remove keys that are NOT in master? 
        # No, better to keep them as they might be language specific or legacy.
        # But for this task, we focus on adding missing ones.

        # Save updated file
        with open(target_path, 'w', encoding='utf-8') as f:
            json.dump(target_data, f, indent=4, ensure_ascii=False)
            
        print(f"Updated {target_file}: Added {added_count} keys, Modified {updated_count} keys.")

if __name__ == "__main__":
    update_arb_files()
