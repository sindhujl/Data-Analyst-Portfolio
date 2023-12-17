use ig_clone;

select id,username,created_at from users 
order by created_at asc Limit 5;

#Users who never posted an image.
SELECT U.id,U.username FROM users U 
LEFT JOIN photos P
ON P.user_id = U.id
WHERE P.image_url is null;

#User with most likes on a single photo.
use ig_clone;
SELECT
    u.id,
    u.username,
    l.photo_id,
    COUNT(*) AS total_likes
FROM
    users u
JOIN
    photos p ON u.id = p.user_id
JOIN
    likes l ON p.id = l.photo_id
GROUP BY
    p.id
ORDER BY
    total_likes DESC;
    
# most used hastags in ig 
SELECT 
	t.tag_name , 
    p.tag_id , 
    COUNT(*) as most_used_tag 
FROM 
     tags t
JOIN 
	photo_tags p ON t.id = p.tag_id 
Group by 
    p.tag_id
Order by 
	most_used_tag desc
LIMIT 5;
    
#insights on which day user register the most on instagram
SELECT 
      dayname(created_at) as day_of_week , count(*) as users_registered 
FROM 
	users
GROUP BY 
	day_of_week
ORDER BY  
    users_registered DESC;
    
# no of photos/ no of users.
select Round((select count(*) from photos)/(select count(*) from users),2) as avg_p ; 

#User Engagement avg no.of posts per user on instagram.
SELECT AVG(posts_count) as avg_posts_per_user
FROM (
select user_id, count(*)  as posts_count from photos
group by user_id
order by posts_count desc) as user_posts;
 
# Users who liked every post on instagram (potential bot)
select count(*) as total_posts_liked , u.id , u.username 
from 
     likes l
join 
	users u on l.user_id=u.id
group by 
	user_id
having 
    total_posts_liked = (select count(*) from photos)
order by u.username asc;


