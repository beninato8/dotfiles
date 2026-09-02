#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "requests",
#   "python-dotenv",
# ]
# ///

import os
import requests
from datetime import datetime, UTC

from dotenv import load_dotenv

load_dotenv()

TOKEN = os.getenv("GITHUB_TOKEN")
if not TOKEN:
    raise ValueError("GitHub token not found. Set it in a .env file.")

GITHUB_USERNAME = "beninato8"

query = """
{
  user(login: "%s") {
    contributionsCollection(from: "%sT00:00:00Z", to: "%sT23:59:59Z") {
      contributionCalendar {
        totalContributions
      }
    }
  }
}
""" % (GITHUB_USERNAME, datetime.now(UTC).date(), datetime.now(UTC).date())

url = "https://api.github.com/graphql"
headers = {"Authorization": f"bearer {TOKEN}"}

response = requests.post(url, json={"query": query}, headers=headers)

if response.status_code == 200:
    data = response.json()
    contributions = data["data"]["user"]["contributionsCollection"]["contributionCalendar"]["totalContributions"]
    print(contributions)
else:
    print("❌")
