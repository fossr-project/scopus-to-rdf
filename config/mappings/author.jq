def name_variant($author_uri):
    with_entries(.key |= ltrimstr("ce:")) |
    {
        "@id": "\($author_uri)/names/\(.surname // "-")/\(."given-name" // "-")/\(."given-name" // "-")/\(."indexed-name" // "-")/\(."initials" // "-")",
        "@type": "pub:Name",
        "pub:fullName": (
            [(."given-name", .surname) | values] |
            if .
                then join(" ")
            else
                null
            end
        ),
        "pub:givenName": ."given-name",
        "pub:surname": .surname,
        "pub:indexedName": ."indexed-name",
        "pub:initials": .initials
    }
;

def main:
    ._id as $author_id |
    @uri "data:authors/\($author_id)" as $author_uri |
    {
        "@id": @uri "data:authors/\($author_id)",
        "@type": "pub:AuthorProfile",
        "pub:hasIdentifier":
            $author_id |
            {
                    "@id": @uri "data:authors/\(.)/id",
                    "@type": "pub:Identifier",
                    "rdfs:value": .,
                    inScheme: "schemes:scopus/author-ids"
            },
        "pub:hasPreferredName":
            ."author-profile"."preferred-name" |
            name_variant($author_uri)
    }
;