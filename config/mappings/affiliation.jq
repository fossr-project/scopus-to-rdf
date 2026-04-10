def main:
    {
        "@id": "data:affiliations/\(._id)",
        "@type": "pub:OrganizationProfile",
        "dc:identifier": ._id,
        "pub:hasIdentifier": {
            "@id": "data:affiliations/\(._id)/id",
            "@type": "pub:Identifier",
            "rdfs:value": ._id,
            inScheme: "schemes:scopus/affiliation-ids"
        },
        "rdfs:label": ."affiliation-name",
        "pub:affPreferredName": ."affiliation-name",
        "pub:affName": [."name-variants"."name-variant".[]? | ."$"],
        "pub:affCountry": .country,
        "pub:affCity": .city
    }
;
