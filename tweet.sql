drop table if exists tweets;
create table tweets (
	id integer primary key,
	place integer,
	goto string,
	text text,
	name string,
	day smalldatetime
);
