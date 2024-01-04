SELECT *
FROM blog_user;

-- Data Manipulation Language (DML)


-- Adding rows to a table
-- Syntax: INSERT INTO table_name(col_name_1, col_name_2, etc.) VALUES (val_1, val_2, etc.)

INSERT INTO blog_user(
	username,
	password_hash,
	email_address,
	first_name,
	last_name,
	middle_name
) VALUES (
	'brians',
	'skfhasfjkhadljdflkd',
	'brians@ct.com',
	'Brian',
	'Stanton',
	'Danger'
);

SELECT *
FROM blog_user;

-- Insert another user
-- ORDER MATTERS!!
INSERT INTO blog_user (
	email_address,
	last_name,
	username,
	password_hash,
	first_name,
	middle_name
) VALUES (
	'sarahs@ct.com',
	'Stodder',
	'sarahs',
	'dfhkadjsfhakjfla',
	'Sarah',
	'Awesome'
);

SELECT *
FROM blog_user;

SELECT *
FROM category;

-- Insert Values Only
-- Syntax: INSERT INTO table_name VALUES (val_1, val_2, etc.)
-- Values follow the original order that the columns were added
INSERT INTO category VALUES (
	1,
	'Technology',
	'The future is now'
);

SELECT *
FROM category;

-- Because we added the first category with the manual entry of ID 1, the serial default
-- did NOT call nextval on the sequence. so it will *initially throw an error if we try to
-- insert a new category using the default ID
INSERT INTO category (
	category_name,
	description
) VALUES (
	'Health & Fitness',
	'Get that body moving!'
);

SELECT *
FROM category;

-- Insert Multiple rows of data in one command
-- Syntax: 
-- INSERT INTO table_name (col_1, col_2, etc.) VALUES (val_a_1, val_a_2, etc), (val_b_1, val_b_2, etc.)
SELECT *
FROM post;

INSERT INTO post(
	title,
	body,
	user_id
) VALUES (
	'Hello World',
	'This is the first post of the database',
	1
), (
	'Another Post',
	'Here is another post that we are adding to the table',
	1
), (
	'Thursday',
	'Today is Thursday. Tomorrow is Friday.',
	2
);

SELECT *
FROM post;

-- Try to add a post with a user that does not exist

-- INSERT INTO post (title, body, user_id) 
-- VALUES ('Hi', 'Will this work?', 123);
-- blog_user with ID 123 does not exist! Will throw an error!

-- Add a few more blog users
INSERT INTO blog_user (
	username,
	password_hash,
	email_address,
	first_name,
	last_name
) VALUES (
	'mickey',
	'sdkfhdkfhdskj',
	'mickey.mouse@disney.com',
	'Mickey',
	'Mouse'
), (
	'minnie',
	'asdjkghdskjlfsdf',
	'minnie.mouse@disney.com',
	'Minnie',
	'Mouse'
);

SELECT *
FROM blog_user;

-- To update existing data in a table
-- Syntax: UPDATE table_name SET col_1 = val_1, col_2 = val_2, etc. WHERE condition

-- User with the ID of 1 wants to change the username to 'bstanton'
UPDATE blog_user 
SET username = 'bstanton'
WHERE user_id = 1;

SELECT *
FROM blog_user
ORDER BY user_id;


UPDATE blog_user
SET middle_name = 'The'
WHERE email_address LIKE '%disney.com';

SELECT *
FROM blog_user;

SELECT *
FROM category;

-- Alter the category table to add a color column
ALTER TABLE category
ADD COLUMN color VARCHAR(7);

-- An UPDATE/SET without a WHERE will update ALL rows
UPDATE category
SET color = '#2121b0';

SELECT *
FROM category;


-- Set multiple columns in one command
SELECT *
FROM post;

UPDATE post
SET title = 'Updated Title', body = 'This text body is updated'
WHERE post_id = 2;

SELECT *
FROM post;


-- Delete data from a table
-- Syntax: DELETE FROM table_name WHERE condition
-- WHERE is not required but HIGHLY RECOMMENDED *without WHERE every row will be deleted

SELECT *
FROM blog_user
ORDER BY user_id;

DELETE FROM blog_user
WHERE last_name = 'Mouse';

SELECT *
FROM blog_user;

-- A DELETE FROM without a WHERE will delete all rows
SELECT *
FROM category;

DELETE FROM category;

SELECT *
FROM category;


-- Delete a user that has a post related to that user
DELETE FROM blog_user
WHERE user_id = 2;

-- To make it so that when we do delete a row, it will delete any rows in related tables
-- that reference that row, we will add ON DELETE CASCADE to foreign key constraint

-- Drop the constraint and then add it back with ON DELETE CASCADE
ALTER TABLE post
DROP CONSTRAINT post_user_id_fkey;

ALTER TABLE post 
ADD FOREIGN KEY(user_id) REFERENCES blog_user(user_id) ON DELETE CASCADE;

SELECT *
FROM blog_user;

SELECT *
FROM post;

DELETE FROM blog_user
WHERE user_id = 2;

SELECT *
FROM blog_user;

SELECT *
FROM post;
