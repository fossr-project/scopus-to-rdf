def main:
    @uri "data:authors/\(._id)"  as $authorId |
    .["author-profile"].["preferred-name"] as $preferredName |
    {
        "@id": $authorId,
        "@type": "pub:AuthorProfile",
        "pub:hasPreferredNameVariant": {
            "@id": "\($authorId)/preferred-name-variant",
            "@type": "pub:AuthorNameVariant",
            "pub:fullName": "\($preferredName["given-name"]) \($preferredName.surname)",
            "pub:givenName": $preferredName["given-name"],
            "pub:surname": $preferredName.surname
        }
    }
;