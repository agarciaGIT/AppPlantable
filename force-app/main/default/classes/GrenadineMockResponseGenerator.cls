@isTest
global class GrenadineMockResponseGenerator implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        
        String  mockResponse= '{'+
		'    "response": [        '+
		'        {'+
		'            "id": 517,'+
		'            "title": "LIBOR Alternative Rates, Technology, and Risk: Understanding and Managing the Challenges!",'+
		'            "duration": 45,'+
		'            "created_at": "2019-10-09T15:49:19-04:00",'+
		'            "updated_at": "2029-10-14T12:27:37-04:00",'+
		'            "parent_id": null,'+
		'            "is_break": false,'+
		'            "visibility_id": "PUB",'+
		'            "start_time": "2019-02-26T07:15:00-05:00",'+
		'            "end_time": "2019-02-26T08:00:00-05:00",'+
		'            "child_ids": [],'+
		'            "ticket_type_ids": [],'+
		'            "requires_signup": false,'+
		'            "card_size": 1,'+
		'            "description": "This session will start with LIBOR transition’s current status and focus on the alternative rates adoption, legacy contracts handling as well as the latest on curve modeling. The presentation will also examine key aspects to consider as institutions embrace the changes.<br><br>Sponsored by Numerix!!",'+
		'            "base_tags": ['+
		'                {'+
		'                    "id": 110,'+
		'                    "name": "Sunrise Education Session",'+
		'                    "taggings_count": 5'+
		'                },'+
		'                {'+
		'                    "id": 112,'+
		'                    "name": "TBBB",'+
		'                    "taggings_count": 2'+
		'                }'+
		'            ],'+
		'            "visibility_name": "Public",'+
		'            "theme_names": ['+
		'                {'+
		'                    "id": 100,'+
		'                    "name": "Track A Part 1"'+
		'                }'+
		'            ],'+
		'            "format": {'+
		'                "id": 59,'+
		'                "name": "Sunrise Session",'+
		'                "images": []'+
		'            },'+
		'            "sorted_published_item_assignments": ['+
		'                {'+
		'                    "sort_order": -715827883,'+
		'                    "person_role": "Participant",'+
		'                    "person": {'+
		'                        "details": null,'+
		'                        "id": 397,'+
		'                        "company": "GARP",'+
		'                        "job_title": null,'+
		'                        "full_publication_name": "Michael Simone"'+
		'                    }'+
		'                },'+
		'                {'+
		'                    "sort_order": 0,'+
		'                    "person_role": "Participant",'+
		'                    "person": {'+
		'                        "details": null,'+
		'                        "id": 295,'+
		'                        "company": "GARP",'+
		'                        "job_title": "VP, ERP Program",'+
		'                        "full_publication_name": "Beth Gould Creller"'+
		'                    }'+
		'                },'+
		'                {'+
		'                    "sort_order": 715827882,'+
		'                    "person_role": "Participant",'+
		'                    "person": {'+
		'                        "details": null,'+
		'                        "id": 770,'+
		'                        "company": "Numerix",'+
		'                        "job_title": null,'+
		'                        "full_publication_name": "Liang Wu"'+
		'                    }'+
		'                }'+
		'            ],'+
		'            "published_room": {'+
		'                "id": 21,'+
		'                "name": "Alvin-Carnegie-Broadway",'+
		'                "published_venue_id": 4'+
		'            },'+
		'            "images": [],'+
		'            "public_documents": []'+
		'        },'+
		'        {'+
		'            "id": 454,'+
		'            "title": "Transition",'+
		'            "duration": 15,'+
		'            "created_at": "2019-02-19T18:02:20-05:00",'+
		'            "updated_at": "2019-02-19T18:02:43-05:00",'+
		'            "parent_id": null,'+
		'            "is_break": true,'+
		'            "visibility_id": "PUB",'+
		'            "start_time": "2019-02-27T08:00:00-05:00",'+
		'            "end_time": "2019-02-27T08:15:00-05:00",'+
		'            "child_ids": [],'+
		'            "ticket_type_ids": [],'+
		'            "requires_signup": false,'+
		'            "card_size": 1,'+
		'            "description": null,'+
		'            "base_tags": [],'+
		'            "visibility_name": "Public",'+
		'            "theme_names": [],'+
		'            "format": {'+
		'                "id": 37,'+
		'                "name": "Break",'+
		'                "images": []'+
		'            },'+
		'            "sorted_published_item_assignments": [],'+
		'            "published_room": null,'+
		'            "images": [],'+
		'            "public_documents": []'+
		'        }'+
		'    ],'+
		'    "count": 7'+
		'}';
        
        // Response for Person Cal
        // 
        String jsnSpeakerResponse=		'{'+
		'    "response": {'+
		'        "id": 397,'+
		'        "company": "GARP",'+
		'        "job_title": null,'+
		'        "publication_name": {'+
		'            "prefix": "",'+
		'            "first": "Michael",'+
		'            "last": "Simone",'+
		'            "suffix": ""'+
		'        },'+
		'        "full_publication_name": "Michael Simone",'+
		'        "public_image_url": "https://cust-images.grenadine.co/grenadine/image/upload/c_fill,f_jpg,g_face,h_368,w_368/v0/GlobalAssociationofRiskProfessionals%28GARP%29/default_bio_image_3.png",'+
		'        "real_name": {'+
		'            "prefix": "",'+
		'            "first": "Michael",'+
		'            "last": "Simone",'+
		'            "suffix": ""'+
		'        },'+
		'        "acceptance_state": null,'+
		'        "invite_state": null,'+
		'        "phone_numbers": ['+
		'            {'+
		'                "id": 265,'+
		'                "number": "201-719-7252",'+
		'                "phone_type": "Work"' +
		'            },'+
		'            {'+
		'                "id": 381,'+
		'                "number": "9737130094",'+
		'                "phone_type": "Work"' +
		'            }'+
		'        ],'+
		'        "email_addresses": ['+
		'            {'+
		'                "id": 544,'+
		'                "email": "michael.simone@garp.com",'+
		'                "isdefault": true,'+
		'                "label": null'+
		'            }'+
		'        ],'+
		'        "registrationDetail": {'+
		'            "id": 110,'+
		'            "registration_number": "",'+
		'            "registration_type": "Event Staff",'+
		'            "registered": true'+
		'        },'+
		'        "documents": [],'+
		'        "publishedProgrammeItemAssignments": ['+
		'            {'+
		'                "published_programme_item_id": 433,'+
		'                "person_id": 397,'+
		'                "person_name": "Michael Simone",'+
		'                "sort_order": 1,'+
		'                "person_role": "OtherParticipant",'+
		'                "time_stamp": "2019-02-19T23:02:18Z",'+
		'                "published_programme_item": {'+
		'                    "id": 433,'+
		'                    "title": "Town Square"'+
		'                }'+
		'            },'+
		'            {'+
		'                "published_programme_item_id": 451,'+
		'                "person_id": 397,'+
		'                "person_name": "Michael Simone",'+
		'                "sort_order": 1,'+
		'                "person_role": "OtherParticipant",'+
		'                "time_stamp": "2019-02-19T23:02:20Z",'+
		'                "published_programme_item": {'+
		'                    "id": 451,'+
		'                    "title": "Town Square"'+
		'                }'+
		'            },'+
		'            {'+
		'                "published_programme_item_id": 526,'+
		'                "person_id": 397,'+
		'                "person_name": "Michael Simone",'+
		'                "sort_order": -715827883,'+
		'                "person_role": "Participant",'+
		'                "time_stamp": "2019-10-14T14:54:26Z",'+
		'                "published_programme_item": {'+
		'                    "id": 526,'+
		'                    "title": "LIBOR Alternative Rates, Technology, and Risk: Understanding and Managing the Challenges!"'+
		'                }'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        //Setting Response for Auth req
        if(req.getEndpoint().contains('oauth/token')){
            res.setBody('{"access_token": "71c9460f9011302ffab2b289a36af186297a9825f766b3365ee7025521cb94f4", "token_type": "Bearer", "expires_in": 7200, "scope": "mobile api", "created_at": 1566764441}');
        }
        // Response for Event__c Object Data
        else if(req.getEndpoint().contains('published_items')){            
         res.setBody(mockResponse);
        }
        // Response for Speaker 
        else if(req.getEndpoint().contains('people')){
             res.setBody(jsnSpeakerResponse);
        }
        res.setStatusCode(200);
        return res;
        
    }
}