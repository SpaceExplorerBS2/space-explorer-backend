select * from planets
where planet_id = $1
ORDER by planet_id
fetch first 1 rows only