CREATE TABLE eComplexJSON (
	 id		int
	,age 		int
	,name		string
	,gender		string
	,tags ARRAY	<int>
	,friends STRUCT	<id:int,name:string>
			);


DROP TABLE ComplexJSON;
CREATE TABLE ComplexJSON (
	 id		int
	,age 		int
	,name		string
	,gender		string
	,tags ARRAY	<int>
	,friends STRUCT	<id:int,name:string>
			)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe';
