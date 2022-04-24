--  Use the instagram_clone database
USE instagram_clone;
-- Challenge 1 :
-- Find the 5 oldest users
SELECT * FROM users
ORDER BY created_at ASC
LIMIT 5;

-- Challenge 2 : Most popular registeration date
-- What day of the week most users register on?
SELECT 
    DAYNAME(created_at) AS reg_day,
    COUNT(*) AS day_count
FROM users
GROUP BY reg_day
ORDER BY day_count DESC
LIMIT 2;

-- Challenge 3 : Inactive Users
-- Find the users who have never posted a photo.
-- BrainStorming:
-- Try to find users from users table who has
-- NULL data in photos table (sounds like a Left Join).  
SELECT
	users.id,
	users.user_name
FROM users
LEFT JOIN photos
	ON users.id = photos.user_id
WHERE photos.image_url IS NULL
ORDER BY users.id;

-- Challenge 4 : THE User
-- Which user got the most likes on a single photo?
-- BrainStorming:
-- First you need to get photo_id with most_likes
-- (photos.image_url) is extra info here.
-- So join photos and likes tables, after you
-- Find the photo id with most likes, You find 
-- the users who it belongs to by adding another join (users).

SELECT
	user_name,
	photos.id AS 'photo id',
    photos.image_url,
    COUNT(*) AS num_likes
FROM photos
INNER JOIN likes
	ON likes.photo_id = photos.id
INNER JOIN users
	ON photos.user_id = users.id
GROUP BY photos.id 
ORDER BY num_likes DESC
LIMIT 1;
 
-- Challenge 5 : Average user posting rate
-- How many times does the average user post? 
-- BrainStorm : Calculate average number of photos per user

SELECT 
	(SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users)
    AS 'Average number of photos per user';

-- Challenge 6 : Top 5 Hashtags
-- What are the top 5 commonly used hashtags?
SELECT 
	tag_name,
    COUNT(*) AS total
FROM tags
INNER JOIN photo_tags
	ON photo_tags.tag_id = tags.id
GROUP BY tag_id
ORDER BY total DESC
LIMIT 5;

-- Challenge 7 : Bots
-- Find users who have liked every
-- single photo on the site.
SELECT 
	user_id,
    user_name,
    COUNT(*) AS num_likes
FROM users
INNER JOIN likes
	ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING num_likes = (SELECT COUNT(*) FROM photos);