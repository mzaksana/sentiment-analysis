import scrapy
from scrapy.crawler import CrawlerProcess

import re 
from xml.dom import minidom

class TokoPediaScraperItem(scrapy.Item):
    title = scrapy.Field()
    link = scrapy.Field()
    desc = scrapy.Field()

class AjaxNext(scrapy.Spider):
    name="AjaxKiller"
    def __init__(self, start_urls=None, *args, **kwargs):
        if start_urls is not None:
            self._start_urls = start_urls
        # else:
        #     self._start_urls = []
        super(AjaxNext, self).__init__(*args, **kwargs)

    def start_requests(self):
        print("================== star ==================")
        yield scrapy.Request(url=self.start_urls, callback=self.parse)

    def parse(self, response):
        print("================== parse ==================")
        print(response.body)


class TokoPediaScraper(scrapy.Spider):
    name = "pro"
    targetName="tokopedia"
    target= "https://www.tokopedia.com"
    count=0
    links=[]
    def start_requests(self):
        with open('../data/src/www.tokopedia.com.html') as fp:
            self.links = fp.readlines()
        for url in self.links:
            url=self.target+self.clear(url);
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        # filename ='../data/pages/'+self.targetName+'-%s.html' % page
        # with open(filename, 'wb') as f:
        #     f.write(response.body)
        # self.log('Saved file %s' % filename)
        self.count+=1;
        print("self.count",self.count)
        print("scraping ::  "+str(self.count)+" <> "+str(len(self.links)))
        # self.autoNext(response.url)
        # print(response.body)    

        c = CrawlerProcess({
            'USER_AGENT': 'Mozilla/5.0',
            'FEED_FORMAT': 'csv',
            'FEED_URI': 'output.csv',
        })
        c.crawl(AjaxNext(start_urls=response.url))
        c.start()

    def clear(self,stri):
        return re.sub("(\\r|)\\n$", "", stri)
