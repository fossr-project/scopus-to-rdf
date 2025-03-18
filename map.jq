{
    "@context": {
        "dcterms": "http://purl.org/dc/terms/",
        "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
        "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
        "owl": "http://www.w3.org/2002/07/owl#",
        "schema": "http://schema.org/",
        "fossr": "http://fossr.eu/kg/onto/",
        "data": "http://fossr.eu/kg/data/"
    },
    "@graph": [
        ."search-results".entry[] |
        .eid as $publicationId |
        {
            "@id": ("data:publications/" + .eid),
            "@type": "schema:ScholarlyArticle",
            "dcterms:title": ."dc:title",
            "dcterms:description": ."dc:description",
            "dcterms:identifier": ."dc:identifier",
            "dcterms:date": {
                "@value": ."prism:coverDate",
                "@type": "http://www.w3.org/2001/XMLSchema#date"
            },
            "owl:sameAs": ("https://doi.org/" + ."prism:doi"),
            "schema:sourceOrganization": [
                .affiliation[]? |
                {
                    "@id": ("data:affiliations/" + .afid),
                    "@type": "schema:Organization",
                    "rdfs:label": .affilname,
                    "schema:address": {
                        "@id": ("data:affiliations/" + .afid + "/address"),
                        "schema:addressLocality": ."affiliation-city",
                        "schema:addressCountry": ."affiliation-country"
                    }
                }
            ],
            "dcterms:creator": [
                .author[]? |
                .authid as $authid |
                {
                    "@id": ("data:authors/" + .authid),
                    "@type": "schema:Person",
                    "rdfs:label": .authname,
                    "schema:givenName": ."given-name",
                    "schema:familyName": .surname,
                    "@reverse": {
                        "fossr:forAuthor": [
                            .afid[]? | {
                                "@id": ("data:authorAffiliations/" + $authid + "-" + ."$"),
                                "@type": "fossr:AuthorAffiliation",
                                "fossr:hasAffiliation": {"@id": ("data:affiliations/" + ."$")},
                                "@reverse": {
                                    "fossr:hasAuthorAffiliation": {
                                        "@id": ("data:publications/" + $publicationId)
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
        }
    ]
}