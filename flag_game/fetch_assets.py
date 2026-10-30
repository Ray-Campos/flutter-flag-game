import os
import json
import requests

# Create directories in the Flutter project root
os.makedirs('assets/flags', exist_ok=True)
os.makedirs('assets/data', exist_ok=True)

# Map regions to the project's PT-BR requirements
continent_map = {
    "Africa": "África",
    "Americas": "América",
    "Asia": "Ásia",
    "Europe": "Europa",
    "Oceania": "Oceania"
}

print("Fetching country data from stable dataset...")
# Using the stable open-source raw JSON mirror
response = requests.get('https://raw.githubusercontent.com/mledoze/countries/master/countries.json')
countries_data = response.json()

if not isinstance(countries_data, list):
    print("Error: Could not retrieve country data.")
    exit(1)

formatted_countries = []

for country in countries_data:
    if not isinstance(country, dict):
        continue
        
    # Safely handle potential None values for cca2
    cca2 = country.get('cca2')
    code = (cca2 or '').lower()
    region_en = country.get('region', '')
    
    # Skip items without valid codes or regions
    if not code or region_en not in continent_map:
        continue
        
    # Extract Portuguese translation for the country name
    translations = country.get('translations', {})
    name_pt = translations.get('por', {}).get('common', country.get('name', {}).get('common', 'Unknown'))
    continent_pt = continent_map[region_en]
    
    formatted_countries.append({
        "code": code,
        "name": name_pt,
        "continent": continent_pt
    })
    
    # Download flag image from FlagCDN
    flag_url = f"https://flagcdn.com/w256/{code}.png"
    flag_path = f"assets/flags/{code}.png"
    
    if not os.path.exists(flag_path):
        try:
            img_data = requests.get(flag_url).content
            with open(flag_path, 'wb') as handler:
                handler.write(img_data)
            print(f"Downloaded flag for {name_pt} ({code})")
        except Exception as e:
            print(f"Failed to download {code}: {e}")

# Save the structured JSON for Flutter to consume
with open('assets/data/countries.json', 'w', encoding='utf-8') as f:
    json.dump(formatted_countries, f, ensure_ascii=False, indent=4)

print(f"Done! {len(formatted_countries)} countries processed and saved.")