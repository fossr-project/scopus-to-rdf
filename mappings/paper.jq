def main:
    @uri "data:publications/\(._id)"  as $publicationId |
    (.author | length) as $num_authors |
    {
        "@id": $publicationId,
        "@type": "pub:Publication",
        "dc:title": ."dc:title",
        "dc:description": ."dc:description",
    #    "dc:identifier": ."dc:identifier",
        "prism:coverDate": {
            "@value": ."prism:coverDate",
            "@type": "http://www.w3.org/2001/XMLSchema#date"
        },
        "owl:sameAs": {"@id": @uri "https://doi.org/\(."prism:doi")"},
        "pub:hasAffiliationSet": {
            "@id": "\($publicationId)/affiliation-set",
            "@type": "pub:AffiliationSet",
            "pub:element": [
                .affiliation[]? |
                {
                    "@id": ("data:affiliations/" + .afid),
                    "@type": "pub:OrganizationProfile",
                    "rdfs:label": .affilname,
                    "pub:affName": .affilname,
                    "pub:affCountry": ."affiliation-country",
                    "pub:affCity": ."affiliation-city"
    #                "schema:address": {
    #                    "@id": ("data:affiliations/" + .afid + "/address"),
    #                    "schema:addressLocality": ."affiliation-city",
    #                    "schema:addressCountry": ."affiliation-country"
    #                }
                }
            ]
        },
        "pub:hasAuthorList":
            {
                "@id": "\($publicationId)/author-list",
                "@type": "pub:AuthorList",
                "pub:first": {
                    "@id": "\($publicationId)/author-list/1"
                },
                "pub:last": {
                    "@id": "\($publicationId)/author-list/\($num_authors)"
                },
                "pub:contains": [
                    .author[]? | #to_entries | .[] |
                    .value.authid as $authid |
                    (."@seq" | tonumber) as $seq |
                    {
                    "@id": "\($publicationId)/author-list/\($seq)",
                        "@type": "AuthorItem",
                        "pub:index": $seq,
                        "pub:relatedAuthor": {
                            "@id": ("data:authors/" + .authid),
                            "@type": "pub:AuthorProfile"
                        },
                        "pub:statedAffiliation": [
                            .afid[]? |  {"@id": ("data:affiliations/" + ."$")}
                        ]
                    } |
                    if $seq > 1 then
                        ."pub:prev" |= {
                            "@id": "\($publicationId)/author-list/\($seq - 1)"
                        }
                    end |
                    if $seq < $num_authors then
                        ."pub:next" |= {
                            "@id": "\($publicationId)/author-list/\($seq + 1)"
                        }
                    end
                ]
            }
    }
;
