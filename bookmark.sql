drop table if exists bookmarks;
create table bookmarks (
	id integer primary key,
	user_id integer,
	busstop integer
);
