def main:
    {
        "@id": ("data:affiliations/" + ._id),
        "@type": "pub:OrganizationProfile",
        "rdfs:label": ."affiliation-name",
        "pub:affName": ."affiliation-name",
        "pub:affCountry": .country,
        "pub:affCity": .city
    }
;
