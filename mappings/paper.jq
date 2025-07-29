import "author" as AUTHOR;

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
                    (.authid // ."@auid") as $author_id |
                    (."@seq" | tonumber) as $seq |
                    ."preferred-name" as $preferred_name |
                    {
                        "@id": "\($publicationId)/author-list/\($seq)",
                        "@type": "pub:AuthorItem",
                        "pub:index": $seq,
                        "pub:relatedAuthor": (
                            {
                                "@id": @uri "data:authors/\($author_id)",
                                "@type": "pub:AuthorProfile"
                            } |
                            if $preferred_name then
                                ."pub:hasPreferredNameVariant" = (
                                    $preferred_name |
                                    AUTHOR::name_variant($author_id)
                                )
                            end
                        ),
                        "pub:statedAffiliation": [
                            .afid[]? |  {
                                "@id": ("data:affiliations/" + ."$")
                            }
                        ],
                        "pub:statedName": AUTHOR::name_variant($author_id)
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
