import os
import json
import requests
import shutil

# Clean up old flags folder to ensure a fresh batch
if os.path.exists('assets/flags'):
    shutil.rmtree('assets/flags')

os.makedirs('assets/flags', exist_ok=True)
os.makedirs('assets/data', exist_ok=True)

continent_map = {
    "Africa": "África",
    "Americas": "América",
    "Asia": "Ásia",
    "Europe": "Europa",
    "Oceania": "Oceania"
}

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'
}

print("Fetching country data from mledoze dataset...")
response = requests.get('https://raw.githubusercontent.com/mledoze/countries/master/countries.json')
countries_data = response.json()

formatted_countries = []

for country in countries_data:
    cca2 = country.get('cca2', '')
    code = cca2.lower() if cca2 else ''
    region_en = country.get('region', '')
    
    if not code or region_en not in continent_map:
        continue
        
    translations = country.get('translations', {})
    name_pt = translations.get('por', {}).get('common', country.get('name', {}).get('common', 'Unknown'))
    continent_pt = continent_map[region_en]
    
    formatted_countries.append({
        "code": code,
        "name": name_pt,
        "continent": continent_pt
    })
    
    #URL format using the exact w2560 size parameter
    flag_url = f"https://flagcdn.com/w2560/{code}.png"
    flag_path = f"assets/flags/{code}.png"
    
    try:
        img_response = requests.get(flag_url, headers=headers)
        
        if img_response.status_code == 200:
            with open(flag_path, 'wb') as handler:
                handler.write(img_response.content)
            print(f"Downloaded flag for {name_pt} ({code})")
        else:
            print(f"Failed to download {code}: HTTP {img_response.status_code}")
            
    except Exception as e:
        print(f"Failed to download {code}: {e}")

with open('assets/data/countries.json', 'w', encoding='utf-8') as f:
    json.dump(formatted_countries, f, ensure_ascii=False, indent=4)

print(f"Done! {len(formatted_countries)} countries processed and saved.")