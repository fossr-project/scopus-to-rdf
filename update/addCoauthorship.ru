PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX fossr: <http://fossr.eu/kg/onto/>

INSERT {?r1 fossr:coauthoredWith ?r2}
WHERE {
  	?r1 ^dcterms:creator/dcterms:creator ?r2.
    FILTER(?r1 != ?r2)
};