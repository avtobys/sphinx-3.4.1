DROP DATABASE IF EXISTS sphinx_test;
CREATE DATABASE sphinx_test;
CREATE TABLE sphinx_test.documents
(
	id			INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
	group_id	INTEGER NOT NULL,
	date_added	DATETIME NOT NULL,
	title		VARCHAR(255) NOT NULL,
	content		TEXT NOT NULL
);

REPLACE INTO sphinx_test.documents ( id, group_id, date_added, title, content ) VALUES
	( 1, 5, NOW(), 'test one', 'this is my test document number one. also checking search within phrases.' ),
	( 2, 6, NOW(), 'test two', 'this is my test document number two' ),
	( 3, 7, NOW(), 'another doc', 'this is another group' ),
	( 4, 8, NOW(), 'doc number four', 'this is to test groups' );
