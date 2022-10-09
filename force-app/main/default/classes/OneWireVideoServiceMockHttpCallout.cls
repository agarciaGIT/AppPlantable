@isTest
global class OneWireVideoServiceMockHttpCallout implements HttpCalloutMock{
    
	global HttpResponse respond(HttpRequest req){
        
        String videoXML = '\n' +
        '<?xml version="1.0" encoding="UTF-8" ?>\n' + 
        '<rss version="2.0">\n' +
            '<channel>\n' + 
                '<title>Upcoming Videos</title>\n' +
                '<link>http://www.onewire.com/Videos</link>\n' +
                '<description>Rss feed of Upcoming Videos from Open Door Series</description>\n' +
                '<lastbuilddate>Fri, 08 Jun 2018 04:00:00 GMT</lastbuilddate>\n' +
                '<language>en-us</language>\n' +
                    '<item>\n' +
                        '<title>Bob Sloan, Managing Partner - S3 Partners</title>\n' +
                        '<link>\n' +
                            'https://www.onewire.com/Videos/Bob-Sloan-S3-Partners\n' +
                        '</link>\n' +
                        '<guid>\n' +
                            'A000001\n' +
                        '</guid>\n' +
                        '<pubdate>\n' +
                            'Fri, 08 Jun 2018 04:00:00 GMT\n' +
                        '</pubdate>\n' +
                        '<description>\n' +
                            'UPDATED VALUE\n' +
                        '</description>\n' +
                    '</item>\n' +
                    '<item>\n' +
                        '<title>Bob Sloan, Managing Partner - S3 Partners</title>\n' +
                        '<link>\n' +
                            'https://www.onewire.com/Videos/Bob-Sloan-S3-Partners\n' +
                        '</link>\n' +
                        '<guid>\n' +
                            'A000008\n' +
                        '</guid>\n' +
                        '<pubdate>\n' +
                            'Fri, 08 Jun 2018 04:00:00 GMT\n' +
                        '</pubdate>\n' +
                        '<description>\n' +
                            'NEW VALUE\n' +
                        '</description>\n' +
                    '</item>\n' +
             '</channel>\n' +
        '</rss>\n';

		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/xml');
		res.setBody(videoXML);
		res.setStatusCode(200);
		return res;
		 
	}	   
    
}