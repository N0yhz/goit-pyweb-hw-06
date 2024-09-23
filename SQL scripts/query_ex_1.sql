SELECT AVG(g.grade) AS avg_grade
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id
JOIN teachers t ON sub.teacher_id = t.id
JOIN students s ON g.student_id = s.id
WHERE t.name = 'Aaron Lynch'  -- teacher name
AND s.name = 'Andrea Weaver'; -- student name