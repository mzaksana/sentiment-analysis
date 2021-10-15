from tokopedia import TokoPediaScraper
from scrapy.crawler import CrawlerProcess

c = CrawlerProcess({
    'USER_AGENT': 'Mozilla/5.0',
    'FEED_FORMAT': 'csv',
    'FEED_URI': 'output.csv',
})
c.crawl(TokoPediaScraper)
c.start()