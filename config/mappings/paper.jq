import "author" as AUTHOR;

def main:
    @uri "data:publications/\(._id)"  as $publicationId |
    {
        "@id": $publicationId,
        "@type": "pub:Publication",
        "dc:title": ."dc:title",
        "dc:description": ."dc:description",
        "dc:identifier": ._id,
        "prism:coverDate": {
            "@value": ."prism:coverDate",
            "@type": "http://www.w3.org/2001/XMLSchema#date"
        },
        "pub:hasIdentifier": [
            {
                "@id": "\($publicationId)/id",
                "@type": "pub:Identifier",
                "rdfs:value": ._id,
                inScheme: "schemes:scopus/pubblication-ids"
            },
            (
                ."prism:doi" |
                if . then {
                    "@id": "\($publicationId)/doi",
                    "@type": "pub:Identifier",
                    "rdfs:value": .,
                    inScheme: "schemes:doi"
                } else empty
                end
            )
        ],
        "owl:sameAs": ."prism:doi" | if . then {"@id": @uri "https://doi.org/\(.)"} end,
        # "pub:hasAffiliationSet": {
        #     "@id": "\($publicationId)/affiliation-set",
        #     "@type": "pub:AffiliationSet",
        #     "pub:element": [
        "pub:hasContributingOrganization": [
            .affiliation[]? |
            {
                "@id": ("data:affiliations/" + .afid),
                "@type": "pub:OrganizationProfile",
                "rdfs:label": .affilname,
                "pub:affName": .affilname,
                "pub:affCountry": ."affiliation-country",
                "pub:affCity": ."affiliation-city"
            }
        ],
        "pub:hasAuthorList":
            .author |
            if . then
                length as $num_authors |
                {
                    "@id": "\($publicationId)/author-list",
                    "@type": "pub:AuthorList",
                    "pub:first": {
                        "@id": "\($publicationId)/author-list/1"
                    },
                    "pub:last": {
                        "@id": "\($publicationId)/author-list/\($num_authors)"
                    },
                    "pub:contains": map(
                        (.authid // ."@auid") as $author_id |
                        (."@seq" | tonumber) as $seq |
                        if $author_id then
                            @uri "data:authors/\($author_id)"
                        else
                            @uri "\($publicationId)/author-list/\($seq)/author"
                        end as $author_uri |
                        {
                            "@id": "\($publicationId)/author-list/\($seq)",
                            "@type": "pub:AuthorItem",
                            "pub:index": $seq,
                            "pub:hasItemContent": (
                                {
                                    "@id": $author_uri,
                                    "@type": "pub:AuthorProfile",
                                    "pub:hasIdentifier":
                                        $author_id |
                                        if . then
                                            {
                                                "@id": @uri "data:authors/\(.)/id",
                                                "@type": "pub:Identifier",
                                                "rdfs:value": .,
                                                inScheme: "schemes:scopus/author-ids"
                                            }
                                        end
                                } 
                                # if ."preferred-name" then
                                #     ."pub:hasPreferredName" = (
                                #         ."preferred-name" |
                                #         AUTHOR::name_variant($author_id)
                                #     )
                                # end
                            ),
                            "pub:hasAffiliationInPublication": [
                                .afid[]? |  {
                                    "@id": ("data:affiliations/" + ."$")
                                }
                            ],
                            "pub:hasName": AUTHOR::name_variant($author_uri)
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
                    )
                }
            end
    }
;
