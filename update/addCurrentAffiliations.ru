PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX schema: <http://schema.org/>
PREFIX fossr: <http://fossr.eu/kg/onto/>

INSERT {?researcher schema:affiliation ?affiliation}
WHERE {
  	[] a schema:ScholarlyArticle;
    	fossr:hasAuthorAffiliation [
    		fossr:forAuthor ?researcher;
    		fossr:hasAffiliation ?affiliation
  		];
    	dcterms:date ?last_publication_date.
    {
        SELECT
            ?researcher
            (MAX(?date) AS ?last_publication_date)
        WHERE {
          	[] a schema:ScholarlyArticle;
    	        fossr:hasAuthorAffiliation/fossr:forAuthor ?researcher;
            	dcterms:date ?date.
        }
        GROUP BY ?researcher
    }
};
