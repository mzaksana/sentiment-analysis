import scrapy

class ProSpider(scrapy.Spider):
    name = 'prospider'
    target_uri='https://www.tokopedia.com/'

    def start_requests(self):
        url = 'https://www.tokopedia.com/p'        
        yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        for ref in response.css('a._2xS5-_VI::attr(href)'):
            print(ref.get())


