SELECT AVG(g.grade) AS avg_grade
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id
JOIN teachers t ON sub.teacher_id = t.id
WHERE t.name = "Brittney Collins"; --teacher name
