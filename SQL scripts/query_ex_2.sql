SELECT s.name AS student_name, g.grade, g.date
FROM grades g
JOIN students s ON g.student_id = s.id
JOIN groups gr ON s.group_id = gr.id
JOIN subjects sub ON g.subject_id = sub.id
WHERE gr.name = 'Group C'  -- group name
AND sub.name = 'History'  -- subject name
AND g.date = (
    SELECT MAX(g2.date)
    FROM grades g2
    JOIN students s2 ON g2.student_id = s2.id
    WHERE s2.group_id = gr.id
    AND g2.subject_id = sub.id
);