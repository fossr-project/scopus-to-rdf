PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX sc: <http://purl.org/science/owl/sciencecommons/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX schema: <http://schema.org/>
PREFIX fossr: <http://fossr.eu/kg/onto/>

INSERT {
	?s ?p ?o
}
WHERE {
  {
  	?s owl:sameAs ?s_alias.
    ?s_alias ?p ?o.
  } UNION {
  	?o owl:sameAs ?o_alias.
    ?s ?p ?o_alias.
  } UNION {
  	?s owl:sameAs ?s_alias.
  	?o owl:sameAs ?o_alias.
  	?s_alias ?p ?o_alias.
  }
}

# SELECT
# 	?s ?p ?o
# WHERE {
#   {
#   	?s owl:sameAs ?s_alias
#   	GRAPH <https://w3id.org/fossr-demo/scopus> {
#       ?s_alias ?p ?o
#   	}
#   } UNION {
#   	?o owl:sameAs ?o_alias
#   	GRAPH <https://w3id.org/fossr-demo/scopus> {
#       ?s ?p ?o_alias
#   	}
#   } UNION {
#   	?s owl:sameAs ?s_alias.
#   	?o owl:sameAs ?o_alias.
#   	GRAPH <https://w3id.org/fossr-demo/scopus> {
#       ?s_alias ?p ?o_alias
#   	}
#   }
# }
#LIMIT 100