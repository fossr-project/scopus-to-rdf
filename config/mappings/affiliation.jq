def main:
    {
        "@id": ("data:affiliations/" + ._id),
        "@type": "pub:OrganizationProfile",
        "rdfs:label": ."affiliation-name",
        "pub:affPreferredName": ."affiliation-name",
        "pub:affName": [."name-variants"."name-variant".[]? | ."$"],
        "pub:affCountry": .country,
        "pub:affCity": .city
    }
;
