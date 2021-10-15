import scrapy

class ProSpider(scrapy.Spider):
    name = 'prospider'
    target_uri='https://www.tokopedia.com/'

    def start_requests(self):
        url = 'https://www.tokopedia.com/p'        
        yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        page = response.url.split("/")[-2]
        filename = 'data/%s.html' % page
        with open(filename, 'w') as f:
            for ref in response.css('a._2xS5-_VI::attr(href)'):
                f.write(ref.get()+"\n")

        self.log('Saved file %s' % filename)