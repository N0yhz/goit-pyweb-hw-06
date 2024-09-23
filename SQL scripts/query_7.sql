SELECT s.name, g.grade, g.date
FROM grades g
JOIN students s ON g.student_id = s.id
JOIN groups gr ON s.group_id = gr.id
JOIN subjects sub ON g.subject_id = sub.id 
WHERE gr.name = 'Group B' -- group name 
AND sub.name = 'Literature'; -- subject name