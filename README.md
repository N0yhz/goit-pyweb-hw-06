# goit-pyweb-hw-06

##**1. database_script.py**

```
import sqlite3
from faker import Faker
import random
from datetime import datetime

fake = Faker()

connection = sqlite3.connect('uas.db')
cursor = connection.cursor()

#creating tables
cursor.execute('''
               CREATE TABLE IF NOT EXISTS groups (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT)
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS students (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    group_id INTEGER,
                    FOREIGN KEY(group_id) REFERENCES groups(id))
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS teachers (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT)
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS subjects (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    teacher_id INTEGER,
                    FOREIGN KEY(teacher_id) REFERENCES teachers(id))
               ''')

cursor.execute('''
               CREATE TABLE IF NOT EXISTS grades (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    student_id INTEGER,
                    subject_id INTEGER,
                    grade INTEGER,
                    date TEXT,
                    FOREIGN KEY(student_id) REFERENCES students(id),
                    FOREIGN KEY(subject_id) REFERENCES subjects(id))
               ''')

# ADDING DATA TO TABLES

# creating students
for _ in range(42):
    cursor.execute("INSERT INTO students (name, group_id) VALUES (?, ?)", 
                   (fake.name(), random.randint(1, 3)))

# creating groups
group_names = ['Group A', 'Group B', 'Group C']
for name in group_names:
    cursor.execute("INSERT INTO groups (name) VALUES (?)", (name,))

# creating teachers
for _ in range(5):
    cursor.execute("INSERT INTO teachers (name) VALUES (?)", (fake.name(),))

# creating subjects
subject_names = ['Math', 'Physics', 'History', 'Literature', 'Chemistry']
teacher_ids = [1, 2, 3, 4, 5]
for i in range(5):
    cursor.execute("INSERT INTO subjects (name, teacher_id) VALUES (?, ?)", 
                   (subject_names[i], random.choice(teacher_ids)))

# creating grades for each student
student_ids = cursor.execute("SELECT id FROM students").fetchall()
subject_ids = cursor.execute("SELECT id FROM subjects").fetchall()

for student_id in student_ids:
    for _ in range(random.randint(5, 20)):  # limit numbers of student's grade to 20
        subject_id = random.choice(subject_ids)[0]
        grade = random.randint(60, 100)
        date = fake.date_between(start_date='-2y', end_date='today').strftime('%Y-%m-%d')
        cursor.execute("INSERT INTO grades (student_id, subject_id, grade, date) VALUES (?, ?, ?, ?)", 
                       (student_id[0], subject_id, grade, date))

connection.commit()
connection.close()
```

##**2. SQL scripts**

<details>
  <summary><i>query_1.sql</i></summary>

```
SELECT students.name, AVG(grades.grade) AS avg_grade
FROM students
JOIN grades ON students.id = grades.student_id
GROUP BY students.id
ORDER BY avg_grade DESC
LIMIT 5;
```
</details>

<details>
  <summary><i>query_2.sql</i></summary>

```
SELECT s.name, AVG(g.grade) AS avg_grade
FROM students s 
JOIN grades  g ON s.id = g.student_id
JOIN subjects sub ON g.subject_id = sub.id 
WHERE sub.name = 'Physics' -- subject name
GROUP BY s.id
ORDER BY avg_grade DESC
LIMIT 1;
```
</details>

<details>
  <summary><i>query_3.sql</i></summary>

```
SELECT gr.name, AVG(g.grade) AS avg_grade
FROM grades g
JOIN students s ON g.id = s.id
JOIN groups gr ON s.group_id = gr.id
JOIN subjects sub ON g.subject_id = sub.id
WHERE sub.name = 'Math' -- subject name
GROUP BY gr.id;
```
</details>

<details>
  <summary><i>query_4.sql</i></summary>

```
SELECT AVG(grade) AS avg_grade
FROM grades;
```
</details>

<details>
  <summary><i>query_5.sql</i></summary>

```
SELECT sub.name
FROM subjects sub
JOIN teachers t ON sub.teacher_id = t.id
WHERE t.name = 'Brittney Collins'; -- teacher name
```
</details>

<details>
  <summary><i>query_6.sql</i></summary>

```
SELECT s.name
FROM students s 
JOIN groups gr ON s.group_id = gr.id 
WHERE gr.name = "Group A"; -- group name
```
</details>

<details>
  <summary><i>query_7.sql</i></summary>

```
SELECT s.name, g.grade, g.date
FROM grades g
JOIN students s ON g.student_id = s.id
JOIN groups gr ON s.group_id = gr.id
JOIN subjects sub ON g.subject_id = sub.id 
WHERE gr.name = 'Group B' -- group name 
AND sub.name = 'Literature'; -- subject name
```
</details>

<details>
  <summary><i>query_8.sql</i></summary>

```
SELECT AVG(g.grade) AS avg_grade
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id
JOIN teachers t ON sub.teacher_id = t.id
WHERE t.name = "Brittney Collins"; --teacher name
```
</details>

<details>
  <summary><i>query_9.sql</i></summary>

```
SELECT sub.name
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id
JOIn students s ON g.student_id = s.id 
WHERE s.name = "Joseph Bailey MD"; --student name
```
</details>

<details>
  <summary><i>query_10.sql</i></summary>

```
SELECT sub.name
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id 
JOIN students s ON g.student_id = s.id 
JOIN teachers t ON sub.teacher_id = t.id 
WHERE s.name = 'Joseph Bailey MD' -- student name
AND t.name = 'Brittney Collins'; -- teacher name
```
</details>

##**3. Extra task SQL scripts**
<details>
  <summary><i>query_ex_1.sql</i></summary>

```
SELECT AVG(g.grade) AS avg_grade
FROM grades g
JOIN subjects sub ON g.subject_id = sub.id
JOIN teachers t ON sub.teacher_id = t.id
JOIN students s ON g.student_id = s.id
WHERE t.name = 'Aaron Lynch'  -- teacher name
AND s.name = 'Andrea Weaver'; -- student name
```
</details>

<details>
  <summary><i>query_ex_2.sql</i></summary>

```
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
```
</details>
