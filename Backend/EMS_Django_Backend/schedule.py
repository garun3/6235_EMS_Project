import time
from scrapers.gccscraper import run_scrape

print("Running scraper once every 60 seconds...press CTRL + C to stop")
while True:
    try:
        run_scrape()
        time.sleep(60)
    except KeyboardInterrupt:
        exit()
