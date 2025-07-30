def name_variant($author_id):
    with_entries(.key |= ltrimstr("ce:")) |
    {
        "@id": @uri "data:authors/\($author_id)/names/\(.surname // "-")/\(."given-name" // "-")/\(."given-name" // "-")/\(."indexed-name" // "-")/\(."initials" // "-")",
        "@type": "pub:AuthorNameVariant",
        "pub:fullName": "\(."given-name") \(.surname)",
        "pub:givenName": ."given-name",
        "pub:surname": .surname,
        "pub:indexedName": ."indexed-name",
        "pub:initials": .initials
    }
;

def main:
    ._id as $author_id |
    ."author-profile"."preferred-name" as $preferredName |
    {
        "@id": @uri "data:authors/\($author_id)",
        "@type": "pub:AuthorProfile",
        "pub:hasPreferredNameVariant":
            ."author-profile"."preferred-name" |
            name_variant($author_id)
    }
;