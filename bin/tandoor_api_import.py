#!/usr/bin/env python3
"""
Import Mealie-format recipe JSON files into Tandoor via its REST API.

Usage:
  tandoor_api_import.py --url https://recipes.coffie.no --token TOKEN --dir ./recipes
  tandoor_api_import.py --url https://recipes.coffie.no --token TOKEN --dir ./recipes --recipe "cod"
  tandoor_api_import.py --url https://recipes.coffie.no --token TOKEN --dir ./recipes --dry-run
"""

import json
import glob
import time
import argparse
import sys
import os

try:
    import requests
except ImportError:
    print("Error: 'requests' package is required. Install with: pip install requests")
    sys.exit(1)


# ─────────────────────────────────────────────
# Helpers
# ─────────────────────────────────────────────

def api(session, base_url, method, path, **kwargs):
    url = f"{base_url}/api{path}"
    try:
        resp = getattr(session, method)(url, timeout=30, **kwargs)
    except requests.ConnectionError:
        print(f"  !! Connection error: {method.upper()} {path}")
        return None
    except requests.Timeout:
        print(f"  !! Timeout: {method.upper()} {path}")
        return None
    if not resp.ok:
        print(f"  !! {method.upper()} {path} -> {resp.status_code}: {resp.text[:200]}")
    return resp


def get_or_create(session, base_url, endpoint, name, cache):
    """Search-first, create-if-missing pattern for keywords, foods, and units."""
    if not name or not name.strip():
        return None
    key = name.lower().strip()
    if key in cache:
        return cache[key]
    r = api(session, base_url, "get", f"/{endpoint}/", params={"query": name, "page_size": 5})
    if r and r.ok:
        for item in r.json().get("results", []):
            if item["name"].lower() == key:
                cache[key] = item["id"]
                return item["id"]
    r = api(session, base_url, "post", f"/{endpoint}/", json={"name": name.strip()})
    if r and r.ok:
        item_id = r.json()["id"]
        cache[key] = item_id
        return item_id
    return None


def parse_ingredient(ing, session, base_url, unit_cache, food_cache):
    """Convert a Mealie ingredient object into a Tandoor ingredient payload."""
    qty = ing.get("quantity")
    unit = ing.get("unit")
    food = ing.get("food", {})
    note = ing.get("note", "")

    food_name = food.get("name", "").strip() if isinstance(food, dict) else ""
    unit_name = unit.get("name", "").strip() if isinstance(unit, dict) else ""

    if not food_name:
        return None

    food_id = get_or_create(session, base_url, "food", food_name, food_cache)
    unit_id = get_or_create(session, base_url, "unit", unit_name, unit_cache) if unit_name else None

    amount = qty if qty and qty != 0 else 0

    return {
        "food": {"id": food_id, "name": food_name} if food_id else None,
        "unit": {"id": unit_id, "name": unit_name} if unit_id else None,
        "amount": amount,
        "note": note or "",
        "order": 0,
        "is_header": False,
        "no_amount": amount == 0 and not unit_name,
    }


def parse_time(t):
    """Parse a human time string like '20 min' or '1 h 30 min' into minutes."""
    if not t:
        return 0
    t = t.strip().lower()
    minutes = 0
    # Handle "1 h 30 min" or "1h30m" style
    if "h" in t:
        parts = t.split("h")
        try:
            minutes += int(parts[0].strip()) * 60
        except ValueError:
            pass
        t = parts[1] if len(parts) > 1 else ""
    # Handle remaining minutes
    t = t.replace("min", "").replace("m", "").strip()
    if t:
        try:
            minutes += int(t)
        except ValueError:
            pass
    return minutes


# ─────────────────────────────────────────────
# Main import function
# ─────────────────────────────────────────────

def import_recipe(mealie_recipe, session, base_url, keyword_cache, unit_cache, food_cache, dry_run=False):
    name = mealie_recipe.get("name", "")
    print(f"\n--- {name}")

    if dry_run:
        tags = mealie_recipe.get("tags", [])
        ings = mealie_recipe.get("recipeIngredient", [])
        steps = mealie_recipe.get("recipeInstructions", [])
        print(f"  [dry-run] {len(ings)} ingredients, {len(steps)} steps, tags: {tags}")
        return True

    # 1. Keywords
    keyword_ids = []
    for tag in mealie_recipe.get("tags", []):
        kid = get_or_create(session, base_url, "keyword", tag, keyword_cache)
        if kid:
            keyword_ids.append({"id": kid, "name": tag})

    # 2. Nutrition
    nutr_in = mealie_recipe.get("nutrition", {})
    nutrition_payload = {}
    if nutr_in:
        field_map = {
            "calories": "calories",
            "proteins": "proteinContent",
            "carbohydrates": "carbohydrateContent",
            "fats": "fatContent",
            "fiber": "fiberContent",
        }
        for tandoor_key, mealie_key in field_map.items():
            v = nutr_in.get(mealie_key)
            if v is not None:
                try:
                    nutrition_payload[tandoor_key] = float(v)
                except (ValueError, TypeError):
                    pass

    # 3. Description (max 512 chars) — notes moved to last step
    description = mealie_recipe.get("description", "").strip()
    if len(description) > 512:
        description = description[:509] + "..."

    notes_block = ""
    notes = mealie_recipe.get("notes", [])
    if notes:
        notes_lines = []
        for note in notes:
            t = note.get("title", "").strip()
            tx = note.get("text", "").strip()
            if t and tx:
                notes_lines.append(f"**{t}**\n{tx}")
            elif tx:
                notes_lines.append(tx)
        if notes_lines:
            notes_block = "\n\n📝 Notes:\n" + "\n\n".join(notes_lines)

    # 4. Timings
    working_time = parse_time(mealie_recipe.get("prepTime"))
    waiting_time = parse_time(mealie_recipe.get("performTime"))

    # 5. Steps — all ingredients go into step 1
    steps_in = mealie_recipe.get("recipeInstructions", [])
    ingredients_in = mealie_recipe.get("recipeIngredient", [])

    steps_payload = []
    for i, step in enumerate(steps_in):
        step_text = step.get("text", "").strip()
        step_title = step.get("title", "").strip()
        if not step_text:
            continue

        step_ingredients = []
        if i == 0:
            for ing in ingredients_in:
                ing_payload = parse_ingredient(ing, session, base_url, unit_cache, food_cache)
                if ing_payload and ing_payload.get("food"):
                    step_ingredients.append(ing_payload)

        steps_payload.append({
            "name": step_title,
            "instruction": step_text,
            "ingredients": step_ingredients,
            "time": 0,
            "order": i,
            "show_as_header": False,
        })

    # 6. Append notes to last step or create a dedicated Notes step
    if notes_block:
        if steps_payload:
            steps_payload[-1]["instruction"] += notes_block
        else:
            steps_payload.append({
                "name": "Notes",
                "instruction": notes_block.strip(),
                "ingredients": [],
                "time": 0,
                "order": 0,
                "show_as_header": False,
            })

    # 7. Create the recipe
    recipe_payload = {
        "name": name,
        "description": description,
        "servings": mealie_recipe.get("servings", 2),
        "servings_text": "portions",
        "working_time": working_time,
        "waiting_time": waiting_time,
        "keywords": keyword_ids,
        "steps": steps_payload,
        "source_url": "",
        "private": False,
    }
    if nutrition_payload:
        recipe_payload["nutrition"] = nutrition_payload

    r = api(session, base_url, "post", "/recipe/", json=recipe_payload)
    if r and r.ok:
        rid = r.json().get("id")
        print(f"  OK created id={rid}")
        return True
    else:
        status = r.status_code if r else "no response"
        detail = r.text[:300] if r else "connection failed"
        print(f"  FAILED: {status} {detail}")
        return False


# ─────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Import Mealie recipe JSON files into Tandoor")
    parser.add_argument("--url", required=True, help="Tandoor base URL, e.g. https://recipes.coffie.no")
    parser.add_argument("--token", required=True, help="Tandoor API token")
    parser.add_argument("--dir", required=True, help="Directory containing Mealie JSON files")
    parser.add_argument("--recipe", default=None, help="Only import recipes whose name contains this string (case-insensitive)")
    parser.add_argument("--dry-run", action="store_true", help="Parse and show what would be imported without creating anything")
    args = parser.parse_args()

    base_url = args.url.rstrip("/")

    session = requests.Session()
    session.headers.update({
        "Authorization": f"Bearer {args.token}",
        "Content-Type": "application/json",
    })

    # Test connection
    try:
        r = session.get(f"{base_url}/api/recipe/", params={"page_size": 1}, timeout=10)
    except (requests.ConnectionError, requests.Timeout) as e:
        print(f"Cannot connect to Tandoor at {base_url}: {e}")
        sys.exit(1)
    if not r.ok:
        print(f"Cannot connect to Tandoor at {base_url} (status {r.status_code})")
        sys.exit(1)
    print(f"Connected to {base_url}")

    # Load recipe files
    recipe_dir = os.path.expanduser(args.dir)
    recipe_files = sorted(glob.glob(os.path.join(recipe_dir, "*.json")))
    if not recipe_files:
        print(f"No JSON files found in {recipe_dir}")
        sys.exit(1)

    # Filter by recipe name if requested (read each file to check the name field)
    if args.recipe:
        filtered = []
        needle = args.recipe.lower()
        for fpath in recipe_files:
            with open(fpath, encoding="utf-8") as f:
                data = json.load(f)
            if needle in data.get("name", "").lower():
                filtered.append(fpath)
        recipe_files = filtered
        print(f"Filtered to {len(recipe_files)} recipe(s) matching '{args.recipe}'")

    if not recipe_files:
        print("No recipes to import.")
        sys.exit(0)

    print(f"Found {len(recipe_files)} recipe(s) to import")

    keyword_cache = {}
    unit_cache = {}
    food_cache = {}
    failed = []

    ok = 0
    for fpath in recipe_files:
        with open(fpath, encoding="utf-8") as f:
            recipe = json.load(f)
        try:
            success = import_recipe(
                recipe, session, base_url,
                keyword_cache, unit_cache, food_cache,
                dry_run=args.dry_run,
            )
        except Exception as e:
            print(f"  FAILED: {e}")
            success = False

        if success:
            ok += 1
        else:
            failed.append(recipe.get("name", os.path.basename(fpath)))

        time.sleep(0.3)

    print(f"\n{'='*40}")
    print(f"Done: {ok} imported, {len(failed)} failed")
    if args.dry_run:
        print("(dry-run mode — nothing was created)")
    if failed:
        print("\nFailed recipes:")
        for name in failed:
            print(f"  - {name}")
        sys.exit(1)


if __name__ == "__main__":
    main()
