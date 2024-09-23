SELECT sub.name
FROM subjects sub
JOIN teachers t ON sub.teacher_id = t.id
WHERE t.name = 'Brittney Collins'; -- teacher name