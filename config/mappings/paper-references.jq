import "paper" as PAPER;

def main:
    @uri "data:publications/\(._id)"  as $publicationId |
    (.references | length) as $num_references |
    {
        "@id": $publicationId,
        "@type": "pub:Publication",
        "pub:hasReferenceList": {
            "@id": "\($publicationId)/reference-list",
            "@type": "pub:ReferenceList",
            "pub:first": {
                "@id": "\($publicationId)/reference-list/1"
            },
            "pub:last": {
                "@id": "\($publicationId)/reference-list/\($num_references)"
            },
            "pub:contains": [
                .references[]? |
                (."@id" | tonumber) as $seq |
                {
                    "@id": "\($publicationId)/reference-list/\($seq)",
                    "@type": "pub:ReferenceItem",
                    "pub:index": $seq,
                    "pub:relatedPublication": (
                        ._id = ."scopus-id" |
                        ."dc:title" = .title |
                        .author = ."author-list".author |
                        ."prism:doi" = ."ce:doi" |
                        PAPER::main
                    )
                } |
                if $seq > 1 then
                    ."pub:prev" |= {
                        "@id": "\($publicationId)/reference-list/\($seq - 1)"
                    }
                end |
                if $seq < $num_references then
                    ."pub:next" |= {
                        "@id": "\($publicationId)/reference-list/\($seq + 1)"
                    }
                end
            ]
        }
    }
;