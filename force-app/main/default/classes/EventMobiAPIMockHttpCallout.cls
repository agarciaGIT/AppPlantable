global class EventMobiAPIMockHttpCallout implements HttpCalloutMock {
    
    private Integer reponseStatusCode;

    global EventMobiAPIMockHttpCallout(Integer reponseStatusCode){
        this.reponseStatusCode = reponseStatusCode;
    }
    
	global HttpResponse respond(HttpRequest req) {

        String jsonString = null;

        String endpoint = req.getEndpoint();
        
        if(endpoint.contains('people/groups')) {
            jsonString = '{"type":"collection","status":' + this.reponseStatusCode + ',"errors":null,"data":[{"id":"d5c648a5-0ba3-4c73-92ef-40f51021823d","name":"Attendees","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"aed7027a-4204-45e5-ad94-84b115a71872","name":"Speakers","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"f0b4b878-5c9e-4513-8b6d-cc1919174c32","name":"FRM/ERP Certified","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"fdb054d5-f18b-4d0d-bb9a-4380bd58a44a","name":"GARP Risk Convention 2020","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"5c82df1b-fc81-4b53-9f4e-1f78763f0ddb","name":"GARP Risk Conference Europe","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"3909565b-87ad-4cbf-a760-74a3a85eb8ba","name":"Staff","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"9544847d-34f6-449c-9117-774e6fbcf141","name":"Master Class B: Financial Crimes, Risk and Compliance: Fortifying the Battle Lines","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"de7d18db-4d69-47cb-aa9c-bb1200195845","name":"Master Class A: Innovations in Finance: How Fintech, AI and Machine Learning are Transforming Financial Risk Management","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"48d22cc5-4861-49f6-b243-c90a004f47a8","name":"Sponsor","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"d1be7c85-3388-4f20-ae56-1940d985e399","name":"Booth Rep","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"00f888d4-e9f8-4b4a-a715-8391616920e2","name":"Master Class Only","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"fdf27f63-09ae-4d4f-90fb-a8699946fdfc","name":"Speaker","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"},{"id":"ed1c6a81-878b-4d73-ab70-6a9a3b2601e3","name":"2020 Senior Risk Executive Program","event_id":"535d65b7-aff1-4985-b5da-e16e612023ad"}],"meta":{"pagination":{"limit":250,"offset":0,"sort":"created_at","returned_record_count":13,"total_record_count":13,"next_page":null,"previous_page":null},"async":false,"request":{"method":"GET","url":"/v2/events/535d65b7-aff1-4985-b5da-e16e612023ad/people/groups","query":"","request_start_datetime":1580761207.5147154,"request_id":"02ea7ef8-35c9-4044-85ad-2b7c6f434e1b"}}}';        
        }else if(endpoint.contains('sessions/resources')) {
            if(endpoint.contains('roles') && endpoint.contains('people')) {
                jsonString = '{"type":"detail","status":' + this.reponseStatusCode + ',"data":{"event_id":"11fb9acf-b218-4bde-88db-3ba26867b362","session_id":"b7bd3388-7734-4395-b119-5afc468af707","role_id":"e59c2d0d-d3be-43fb-a1ee-9e0880ceaf99","people_ids":["bEVwCX","mHMWfK"]},"errors":null,"meta":{}}';
            }else {
                jsonString = '{ "type": "detail", "status": ' + this.reponseStatusCode + ', "data": { "id": "a2e1W0000003aebQAA", "event_id": "27616df6-8e17-4a0d-b6d8-268115313099", "name": "FRM and ERP Luncheon", "description": "Exclusive lunch for Certified FRMs and ERPs. Advance registration required.", "location": null, "start_datetime": "2018-03-06T11:50:00-05:00", "end_datetime": "2018-03-06T12:50:00-05:00", "track_ids": [], "tracks": [], "created_at": "2018-02-12T19:18:04", "updated_at": "2018-02-12T19:18:04", "roles": [ { "id": "a94d2c1e-97f9-4fa1-8063-831eff0253d4", "name": "Attendee", "people_ids": [] }, { "id": "71947841-a973-4268-9ae5-7e5dcc3644db", "name": "Speaker", "people_ids": [] } ] }, "errors": null, "meta": { "pagination": null, "async": false, "request": { "method": "GET", "url": "/v2/events/27616df6-8e17-4a0d-b6d8-268115313099/sessions/resources/a2e1W0000003aebQAA", "query": "", "request_start_datetime": 1518539773.044633, "request_id": null } } }';
            }
        }else if(endpoint.contains('sessions/tracks')) {
            jsonString = '{ "type": "detail", "status": ' + this.reponseStatusCode + ', "data": { "id": "a2d40000000BvNUAA0", "name": "GARP Introducer for MC A", "color": "007eac", "event_id": "27616df6-8e17-4a0d-b6d8-268115313099" }, "errors": null, "meta": { "pagination": null, "async": false, "request": { "method": "GET", "url": "/v2/events/27616df6-8e17-4a0d-b6d8-268115313099/sessions/tracks/a2d40000000BvNUAA0", "query": "", "request_start_datetime": 1518539847.4934583, "request_id": null } } }';
        }else if(endpoint.contains('sessions/roles')) {
            jsonString = '{ "type": "collection", "status": ' + this.reponseStatusCode + ', "data": [ { "id": "a94d2c1e-97f9-4fa1-8063-831eff0253d4", "event_id": "27616df6-8e17-4a0d-b6d8-268115313099", "name": "Attendee", "type": "attendee" }, { "id": "71947841-a973-4268-9ae5-7e5dcc3644db", "event_id": "27616df6-8e17-4a0d-b6d8-268115313099", "name": "Speaker", "type": "speaker" } ], "errors": null, "meta": { "pagination": { "limit": 250, "offset": 0, "sort": "created_at", "returned_record_count": 2, "total_record_count": 2, "next_page": null, "previous_page": null }, "async": false, "request": { "method": "GET", "url": "/v2/events/27616df6-8e17-4a0d-b6d8-268115313099/sessions/roles", "query": "", "request_start_datetime": 1518538798.9727893, "request_id": null } } }';
        }else if(endpoint.contains('people/resources')) {
            jsonString = '{ "type": "detail", "status": ' + this.reponseStatusCode + ', "data": { "id": "a2f2a0000008zzgAAA", "event_id": "27616df6-8e17-4a0d-b6d8-268115313099", "first_name": "JOHNIE", "last_name": "SMYTHE", "email": "johnie.smythe@test.com", "company": "TEST CO", "title": "TEST GUY", "about": null, "group_ids": [ "2c63ccb1-eb24-4895-a194-955424a91582" ], "groups": [ { "id": "2c63ccb1-eb24-4895-a194-955424a91582", "name": "Speakers" } ], "session_roles": [ { "id": "a94d2c1e-97f9-4fa1-8063-831eff0253d4", "name": "Attendee", "session_ids": [] }, { "id": "71947841-a973-4268-9ae5-7e5dcc3644db", "name": "Speaker", "session_ids": [ "a2e400000003Wi0AAE" ] } ], "custom_fields": {}, "settings": { "direct_messaging": true, "offline_email_messaging": true }, "image_url": null, "created_at": "2018-02-13T16:22:22", "updated_at": "2018-02-13T16:22:22" }, "errors": null, "meta": { "pagination": null, "async": false, "request": { "method": "GET", "url": "/v2/events/27616df6-8e17-4a0d-b6d8-268115313099/people/resources/a2f2a0000008zzgAAA", "query": "", "request_start_datetime": 1518538997.1595871, "request_id": null } } }';
        }
        
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(jsonString);
		return res;
		 
	}	    
    
}