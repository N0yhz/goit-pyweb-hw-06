SELECT sub.name
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id
JOIn students s ON g.student_id = s.id 
WHERE s.name = "Joseph Bailey MD"; --student name