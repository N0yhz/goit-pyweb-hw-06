SELECT gr.name, AVG(g.grade) AS avg_grade
FROM grades g
JOIN students s ON g.id = s.id
JOIN groups gr ON s.group_id = gr.id
JOIN subjects sub ON g.subject_id = sub.id
WHERE sub.name = 'Math' -- subject name
GROUP BY gr.id;