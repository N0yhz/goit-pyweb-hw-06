SELECT sub.name
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id 
JOIN students s ON g.student_id = s.id 
JOIN teachers t ON sub.teacher_id = t.id 
WHERE s.name = 'Joseph Bailey MD' -- student name
AND t.name = 'Brittney Collins'; -- teacher name